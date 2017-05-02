class RequestNotifier 

  def perform
    logger ||= Rails.logger
    
    begin
      StaffingRequest.approved.not_broadcasted.each do |staffing_request|
        # Select a 
        # 1 care giver 
        # 2 who is verified 
        # 3 who has not been selected before
        # 4 who has not been assigned on this date else where
        # 5 who has not rejected this request - perhaps because of another external engagement
        selected_user = nil
        
        User.care_givers.verified.order("auto_selected_date ASC").each do |user|
        
          # Check if this user has been assigned another request on the same day
          # Get the not rejected responses of this user and see if they are for the same day
          same_day_bookings = user.staffing_responses.not_rejected.includes(:staffing_request)
          .where("staffing_requests.start_date <= ? and staffing_requests.end_date >= ?", 
                  staffing_request.start_date, staffing_request.start_date).references(:staffing_request)
          
          logger.debug "same_day_bookings = #{same_day_bookings.length}"

          if(same_day_bookings.length == 0) 
            selected_user = user
            break
          end
        
        end

        if selected_user
          # Create the response from the selected user and mark him as auto selected
          selected_user.auto_selected_date = Date.today
          staffing_response = StaffingResponse.new(staffing_request_id: staffing_request.id, 
              user_id: selected_user.id, 
              hospital_id:staffing_request.hospital_id,
              response_status: "Pending")
          staffing_request.broadcast_status = "Sent"
          StaffingResponse.transaction do
            staffing_response.save        
            selected_user.save
            staffing_request.save
          end

          # Notify the selected_user TODO
        else
          logger.error "No user found for Staffing Request #{staffing_request.id}"
        end
      end

    rescue Exception => e
      logger.error "Error in RequestNotifier"
      logger.error e.backtrace
    ensure  
      # Run this again
      Delayed::Backend::ActiveRecord::Job.enqueue(RequestNotifier.new, :priority=> 0, :run_at=>1.minute.from_now)
    end
    return nil
    
  end

  def self.add_to_queue
    if Delayed::Backend::ActiveRecord::Job.where("handler like '%RequestNotifier%'").count == 0
      puts "RequestNotifier queued"
      Delayed::Backend::ActiveRecord::Job.enqueue(RequestNotifier.new, :priority=> 0)
    else
      puts "RequestNotifier already queued. Nothing done"
    end    
  end

end