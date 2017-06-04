class SlotCreatorJob < ApplicationJob
  queue_as :default

  def perform
    logger ||= Delayed::Worker.logger

    begin
      # For each open request which has not yet been broadcasted
      StaffingRequest.open.not_broadcasted.each do |staffing_request|

        # Select a temp who can be assigned this slot
        selected_user = select_user(staffing_request)

        # If we find a suitable temp - create a slot
        if selected_user
          create_slot(selected_user, staffing_request)
        else
          logger.error "SlotCreatorJob: No user found for Staffing Request #{staffing_request.id}"
          if(staffing_request.slot_status != "Not Found")
            UserNotifierMailer.no_slot_found(staffing_request).deliver
          end
          staffing_request.slot_status = "Not Found"
          staffing_request.save
        end
      end

    rescue Exception => e
      logger.error "SlotCreatorJob: #{e.message}"
      logger.error e.backtrace
    ensure
      # Run this again
      SlotCreatorJob.set(wait: 1.minute).perform_later
    end
    return nil

  end

  def self.add_to_queue
    if Delayed::Backend::ActiveRecord::Job.where("handler like '%SlotCreatorJob%'").count == 0
      logger.info "SlotCreatorJob: queued"
      SlotCreatorJob.set(wait: 1.minute).perform_later
    else
      logger.info "SlotCreatorJob: already queued. Nothing done"
    end
  end

  ### Private Methods Follow ###
  # private
  def get_same_day_booking(user, staffing_request)

    # Check if this user has been assigned another request on the same day
    # For other requests, he should have "Accepted" slots
    # If the start or end date of the response lies inside the start or end date of the request then its a same day booking
    # If the start date is before and the end date is after then also its a same day booking

    # response.start_date > request.start_date && response.start_date < request.end_date
    # response.end_date > request.start_date && response.end_date < request.end_date
    # response.start_date < request.start_date && response.end_date > request.end_date

    # The confusing part of this where clause is that staffing_responses do not have start end dates
    # In the query below, in the where clause all start and end dates are the
    # staffing responses dates via its relationship to the staffing request

    same_day_bookings = user.staffing_responses.not_rejected.includes(:staffing_request)
    .where("(staffing_requests.start_date <= ? and staffing_requests.end_date >= ?)
      or (staffing_requests.start_date <= ? and staffing_requests.end_date >= ?)
      or (staffing_requests.start_date >= ? and staffing_requests.end_date <= ?)",
           staffing_request.start_date, staffing_request.start_date,
           staffing_request.end_date, staffing_request.end_date,
           staffing_request.start_date, staffing_request.end_date).references(:staffing_request)

    logger.debug "SlotCreatorJob: same_day_bookings = #{same_day_bookings.length}"

    return same_day_bookings

  end

  # Check if this user has already rejected this request
  def user_rejected_request?(user, staffing_request)
    user.staffing_responses.rejected.where(staffing_request_id: staffing_request.id).length > 0
  end

  def create_slot(selected_user, staffing_request)

    # Create the response from the selected user and mark him as auto selected
    selected_user.auto_selected_date = Date.today

    # Create the slot
    staffing_response = StaffingResponse.new(staffing_request_id: staffing_request.id,
                                             user_id: selected_user.id,
                                             care_home_id:staffing_request.care_home_id,
                                             response_status: "Pending")
    # Update the request
    staffing_request.broadcast_status = "Sent"
    staffing_request.slot_status = "Found"

    StaffingResponse.transaction do
      staffing_response.save
      selected_user.save
      staffing_request.save
    end
  end

  # UNUSED for now
  # If the request needs a generalist - any speciality can be used
  # Otherwise the speciality of the request must match the Nurse speciality
  def speciality_matches?(staffing_request, user)
    case staffing_request.speciality
    when "Generalist"
      return true
    else
      return staffing_request.speciality == user.speciality
    end
  end

  # UNUSED for now
  # The role required by the staffing_request must be the same as the user role
  # For nurses however we need to further match the speciality
  def matches_role_speciality?(staffing_request, user)

    if(staffing_request.role == user.role)
      case staffing_request.role
      when "Care Giver"
        return true
      when "Nurse"
        return speciality_matches?(staffing_request, user)
      end
    end

    return false

  end

  def pref_commute_ok?(user, staffing_request)
    user.distance_from(staffing_request.care_home) < user.pref_commute_distance
  end

  # Select a
  # 1 care giver
  # 2 who is verified
  # 3 who has not been selected before
  # 4 who has not been assigned on this date else where
  # 5 who has not rejected this request - perhaps because of another external engagement

  def select_user(staffing_request)
    
    selected_user = nil

    User.where(role:staffing_request.role).active.verified.order("auto_selected_date ASC").each do |user|

      Delayed::Worker.logger.debug "SlotCreatorJob: Checking user #{user.email} with request #{staffing_request.id}"

      # Get the slot bookings for this user on the same time as this req
      same_day_bookings = get_same_day_booking(user, staffing_request)
      Delayed::Worker.logger.debug "SlotCreatorJob: #{user.email}, Request #{staffing_request.id}, same_day_bookings = #{same_day_bookings}"

      # Check if this user has already rejected this req
      rejected = user_rejected_request?(user, staffing_request)
      Delayed::Worker.logger.debug "SlotCreatorJob: #{user.email}, Request #{staffing_request.id}, rejected = #{rejected}"

      # Check pref_commute_distance
      commute_ok = pref_commute_ok?(user, staffing_request)
      Delayed::Worker.logger.debug "SlotCreatorJob: #{user.email}, Request #{staffing_request.id}, commute_ok = #{commute_ok}"

      if(same_day_bookings.length == 0 && !rejected && commute_ok)
        Delayed::Worker.logger.debug "SlotCreatorJob: #{user.email}, Request #{staffing_request.id} selected user"
        selected_user = user
        break
      end
    end


    selected_user
  end


end
