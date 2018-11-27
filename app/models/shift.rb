class Shift < ApplicationRecord

  include StartEndTimeHelper

  acts_as_paranoid
  has_paper_trail

  RESPONSE_STATUS = ["Accepted", "Rejected", "Pending", "Auto Rejected", "Closed", "Cancelled"]
  PAYMENT_STATUS = ["UnPaid", "Pending", "Paid"]
  CONFIRMATION_STATUS = ["Pending", "Confirmed"]

  belongs_to :user
  belongs_to :staffing_request
  belongs_to :care_home
  has_one :payment
  has_many :ratings

  # The audit trail of how the price was computed
  serialize :pricing_audit, Hash


  scope :not_rejected, -> {where("response_status <> 'Rejected' and response_status <> 'Auto Rejected'")}
  scope :not_cancelled, -> {where("response_status <> 'Cancelled'")}
  scope :accepted, -> {where("response_status = 'Accepted'")}
  scope :pending, -> {where("response_status = 'Pending'")}
  scope :rejected, -> {where("response_status = 'Rejected'")}
  scope :cancelled, -> {where("response_status = 'Cancelled'")}
  scope :open, -> {where("response_status in ('Pending', 'Accepted')")}

  validate :check_codes
  before_save :shift_cancelled, :shift_accepted, :update_dates
  before_create :set_defaults
  after_save :close_shift
  after_create :broadcast_shift

  attr_accessor :closing_started
  attr_accessor :testing

  # Set by the request when it is cancelled/closed. 
  # see StaffingRequest.update_response_status && Shift.shift_cancelled
  attr_accessor :closed_by_parent_request

  def set_defaults
    self.confirm_sent_count = 0
    self.confirmed_count = 0
    self.notification_count = 0
    # update the request
    self.staffing_request.broadcast_status = "Sent"
    self.staffing_request.shift_status = "Found"
  end


  def self.create_shift(selected_user, staffing_request, preferred_care_giver_selected=false)

    if (staffing_request.shifts.open.where(user_id: selected_user.id).count > 0)
      raise "Open shift already exists for user #{selected_user.id} and staffing_request #{staffing_request.id}"
    else
      # Create the response from the selected user and mark him as auto selected
      selected_user.auto_selected_date = Time.now

      # Create the shift
      shift = Shift.new(staffing_request_id: staffing_request.id,
                        user_id: selected_user.id,
                        care_home_id:staffing_request.care_home_id,
                        response_status: "Pending",
                        preferred_care_giver_selected: preferred_care_giver_selected)
      # Update the request
      prev_shift = staffing_request.shifts.last

      Shift.transaction do
        
        # Cancel any prev shift
        if(prev_shift && prev_shift.response_status == "Pending")
          prev_shift.response_status = "Cancelled"
          prev_shift.save
        end

        # save this new shift
        shift.save!
        # Update the user
        selected_user.save
        # And ensure the staffing request is updated      
        staffing_request.broadcast_status = "Sent"
        staffing_request.shift_status = "Found"      
        staffing_request.save
        
      end

      return shift
    end

  end

  def shift_cancelled
    if(self.response_status_changed? &&
       ["Rejected", "Auto Rejected", "Cancelled"].include?(self.response_status))

      if(!closed_by_parent_request)
        # This was rejected - so ensure the request gets broadcasted again
        # If the broadcast_status is "Pending", the Notifier will pick it
        # up again in some time and send it out
        self.staffing_request.broadcast_status = "Pending"
        self.staffing_request.shift_status = nil
        self.staffing_request.save
      end
      UserNotifierMailer.shift_cancelled(self).deliver_later
      self.send_shift_cancelled_sms(self)
    end
  end

  def shift_accepted
    if(self.response_status_changed? && self.response_status == "Accepted")
      UserNotifierMailer.shift_accepted(self).deliver_later
      self.send_shift_accepted_sms(self)
      # Send a mail to the broacast group with the start / end codes
      UserNotifierMailer.send_codes_to_broadcast_group(self).deliver
    end
  end


  def update_dates
    # Sometimes admin have to manually close a shift, so they supply the start/end codes and dates
    if(!manual_close)
      if(self.start_code_changed?)
        self.start_date = Time.now
        self.start_date = self.start_date.change({sec: 0}) if self.start_date
        UserNotifierMailer.shift_started(self).deliver_later
        self.send_shift_started_sms(self)
      end
      if(self.end_code_changed?)
        # End Time cannot be < 4 hours from start time
        self.end_date = (Time.now - self.start_date)/ (60 * 60) > 4 ? Time.now : (self.start_date + 4.hours)
        self.end_date = self.end_date.change({sec: 0}) if self.end_date
        UserNotifierMailer.shift_ended(self).deliver_later
        self.send_shift_ended_sms(self)
      end
    end
  end

  def broadcast_shift
    if(self.response_status != 'Rejected')
      logger.debug "Broadcasting shift #{self.id}"
      PushNotificationJob.new.perform(self)
      UserNotifierMailer.shift_notification(self).deliver_later
      self.send_shift_sms_notification(self)
    end
  end

  # Used to broadcast the shift n number of times on regular intervals
  def broadcast_shift_again
    max_count = ENV['MAX_SHIFT_NOTIFICATION_COUNT'].to_i
    max_time  = ENV["MAX_PENDING_SLOT_TIME_MINS"].to_i

    time_elapsed =  (Time.now - self.created_at)/60    
    self.notification_count ||= 0
    logger.debug "Brodcasting shift again: #{self.id}, time_elapsed = #{time_elapsed}, notification_count = #{self.notification_count}, #{max_time / max_count}"
    # If we've not sent out the max number of notifications & if the elapsed time is > the next notification time
    # If we have a 30 min MAX_PENDING_SLOT_TIME_MINS
    # And have a MAX_SHIFT_NOTIFICATION_COUNT of 3
    # Then we can send out a notification after every 10 mins 3 times
    if( self.notification_count < max_count && 
        time_elapsed > (max_time / max_count) * (self.notification_count + 1) )
      # Send out the notifications
      self.broadcast_shift
      self.notification_count += 1  
      return self.save
    end

    return false
  end

  def check_codes
    # Codes should match the one in the request
    if(self.start_code && self.start_code.strip != "" && self.start_code != self.staffing_request.start_code)
      errors.add(:start_code, "Start Code does not match with the request start code")
    end

    time_from_now = (self.staffing_request.start_date - Time.now)/60 
    if(!manual_close && self.start_code_changed? && time_from_now > 60 && self.testing != true)  
      errors.add(:start_code, "Shift cannot start before the allotted shift time #{self.staffing_request.start_date.in_time_zone("Europe/London").to_s(:custom_datetime)}")
    end

    if(self.end_code && self.end_code.strip != "" && self.end_code != self.staffing_request.end_code)
      errors.add(:end_code, "End Code does not match with the request end code")
    end
  end

  def close_shift(force=false)
    # Ensure this gets priced, if we have the right star / end codes
    if ( (  !self.closing_started && self.carer_base == nil &&
            self.start_code == self.staffing_request.start_code &&
            self.end_code == self.staffing_request.end_code) || force )

      ShiftCloseJob.perform_later(self.id)
      # This callback gets called multiple times - we want to do this only once. Hence closing_started
      self.closing_started = true

    end
  end



  def send_confirm?
    nct = self.next_confirm_time
    sendFlag =  nct && Time.now > nct && # Time to send the confirm
    			self.response_status == 'Accepted' &&   
                self.start_code == nil && # Shift has not yet started
                self.confirmed_status != "Declined" # Shift has not been rejected by the carer
                
    logger.debug("Shift: sendFlag = #{sendFlag}")
    return sendFlag
  end

  def next_confirm_time
    # ACCEPTED_SLOT_REMINDERS_BEFORE="1.day,4.hours,1.hour"
    reminders = ENV["ACCEPTED_SLOT_REMINDERS_BEFORE"].split(",")
    logger.debug("Shift: next_confirm_time = #{reminders[self.confirm_sent_count]} confirm_sent_count = #{self.confirm_sent_count} ")
    if(reminders.length > self.confirm_sent_count)
      return self.staffing_request.start_date - eval(reminders[self.confirm_sent_count])
    end

    return nil
  end

  def confirmation_sent
    self.confirm_sent_count += 1
    self.confirm_sent_at = Time.now
    self.save!
  end

  def confirm
    self.confirmed_status = "Confirmed"
    self.confirmed_count += 1
    self.confirmed_at = Time.now
    self.save!
  end

  def decline
    self.confirmed_status = "Declined"
    self.confirmed_count += 1
    self.confirmed_at = Time.now
    self.save!
  end

  def confirmation_received?
    self.confirmed_status == "Confirmed" &&  self.confirmed_at > self.confirm_sent_at
  end

  # Used only for testing - do not use in actual code
  def set_codes_test
    self.testing = true
    self.start_code = self.staffing_request.start_code
    self.end_code = self.staffing_request.end_code
    self.save!
    if self.start_date == nil
      self.start_date = self.staffing_request.start_date
    end
    self.end_date = self.start_date + 10.hours
    self.save!
  end



  def send_shift_sms_notification(shift)
    msg = "You have a new shift assigned at #{shift.care_home.name}. Please open the Care Connuct app and accept or reject the shift."
    send_sms(msg)
  end

  def send_shift_accepted_sms(shift)
    msg = "Shift assigned at #{shift.care_home.name} has been accepted."
    send_sms(msg)
  end

  def send_shift_cancelled_sms(shift)
    msg = "Shift assigned at #{shift.care_home.name} has been cancelled."
    send_sms(msg)
  end

  def send_shift_started_sms(shift)
    msg = "Shift assigned at #{shift.care_home.name} has started."
    send_sms(msg)
  end

  def send_shift_ended_sms(shift)
    msg = "Shift assigned at #{shift.care_home.name} has ended."
    send_sms(msg)
  end

  def send_sms(msg)
    self.user.send_sms(msg)
  end

  def self.month_closed_shifts(date=Date.today)
    month_start = date.beginning_of_month
    month_end = date.end_of_month
    # Find all the users who had completed shifts in the prev months
    closed_shifts = Shift.joins(:staffing_request).where(response_status:"Closed").where("staffing_requests.start_date >= ? and staffing_requests.start_date < ?", month_start, month_end + 1.day)
    closed_shifts 
  end

  def create_payment
    Payment.new(shift_id: self.id, user_id: self.user_id, 
      care_home_id: self.care_home_id, paid_by_id: self.staffing_request.user_id,
      billing: self.care_home_base, amount: self.care_home_total_amount, 
      vat: self.vat, markup: self.markup, care_giver_amount: self.carer_base,
      notes: "Thank you for your service.",
      staffing_request_id: self.staffing_request_id,
      created_at: self.end_date)
    
  end

  def generate_anonymous_reject_hash
    Digest::SHA256.hexdigest self.id.to_s + ENV['SHIFT_REJECT_SECRET']
  end

end
