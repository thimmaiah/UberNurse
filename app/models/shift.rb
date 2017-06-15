class Shift < ApplicationRecord

  include StartEndTimeHelper

  acts_as_paranoid
  has_paper_trail

  RESPONSE_STATUS = ["Accepted", "Rejected", "Pending", "Auto Rejected", "Closed"]
  PAYMENT_STATUS = ["UnPaid", "Paid"]
  CONFIRMATION_STATUS = ["Pending", "Confirmed"]

  belongs_to :user
  belongs_to :staffing_request
  belongs_to :care_home
  has_one :payment
  has_one :rating

  # The audit trail of how the price was computed
  serialize :pricing_audit, Hash


  scope :not_rejected, -> {where("response_status <> 'Rejected'")}
  scope :accepted, -> {where("response_status = 'Accepted'")}
  scope :pending, -> {where("response_status = 'Pending'")}
  scope :rejected, -> {where("response_status = 'Rejected'")}
  scope :open, -> {where("response_status in ('Pending', 'Accepted')")}

  validate :check_codes
  before_save :shift_cancelled, :shift_accepted, :update_dates
  before_create :set_defaults
  after_save :close_shift
  after_create :broadcast_shift

  attr_accessor :closing_started

  def set_defaults
    self.confirm_sent_count = 0
    self.confirmed_count = 0
    # update the request
    self.staffing_request.broadcast_status = "Sent"
    self.staffing_request.shift_status = "Found"
  end

  def shift_cancelled
    if(self.response_status_changed? &&
       ["Rejected", "Auto Rejected"].include?(self.response_status))

      # This was rejected - so ensure the request gets broadcasted again
      # If the broadcast_status is "Pending", the Notifier will pick it
      # up again in some time and send it out
      self.staffing_request.broadcast_status = "Pending"
      self.staffing_request.shift_status = nil
      self.staffing_request.save
      UserNotifierMailer.shift_cancelled(self).deliver_later
    end
  end

  def shift_accepted
    if(self.response_status_changed? && self.response_status == "Accepted")
      UserNotifierMailer.shift_accepted(self).deliver_later
    end
  end


  def update_dates
    self.start_date = Time.now if(self.start_code_changed?)
    self.end_date = Time.now if(self.end_code_changed?)
    # Zero out the seconds - it causes lots of problems when calculating time spent
    self.start_date = self.start_date.change({sec: 0}) if self.start_date
    self.end_date = self.end_date.change({sec: 0}) if self.end_date
  end

  def broadcast_shift
    if(self.response_status != 'Rejected')
      PushNotificationJob.new.perform(self)
      UserNotifierMailer.shift_notification(self).deliver_later
    end
  end

  def check_codes
    # Codes should match the one in the request
    if(self.start_code && self.start_code.strip != "" && self.start_code != self.staffing_request.start_code)
      errors.add(:start_code, "Start Code does not match with the request start code")
    end
    if(self.end_code && self.end_code.strip != "" && self.end_code != self.staffing_request.end_code)
      errors.add(:end_code, "End Code does not match with the request end code")
    end
  end

  def close_shift
    # Ensure this gets priced, if we have the right star / end codes
    if(!self.closing_started && price == nil && 
      self.start_code == self.staffing_request.start_code && 
      self.end_code == self.staffing_request.end_code)

      ShiftCloseJob.perform_later(self.id)
      # This callback gets called multiple times - we want to do this only once. Hence closing_started
      self.closing_started = true
    
    end
  end



  def send_confirm?
    sendFlag = Time.now > self.next_confirm_time && self.confirmed_status != "Declined"
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
    self.start_code = self.staffing_request.start_code
    self.end_code = self.staffing_request.end_code
    self.save

    self.end_date = self.start_date + 8.hours
    self.save
  end

end
