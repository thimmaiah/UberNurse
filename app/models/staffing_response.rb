class StaffingResponse < ApplicationRecord

  acts_as_paranoid
  has_paper_trail

  RESPONSE_STATUS = ["Accepted", "Rejected", "Pending"]
  PAYMENT_STATUS = ["UnPaid", "Paid"]

  belongs_to :user
  belongs_to :staffing_request
  belongs_to :hospital
  has_one :payment
  has_one :rating

  scope :not_rejected, -> {where("response_status <> 'Rejected'")}
  scope :accepted, -> {where("response_status = 'Accepted'")}
  scope :open, -> {where("response_status != 'Closed'")}

  before_save :process_rejected
  before_save :update_dates

  def process_rejected
    if(self.response_status_changed? && self.response_status == "Rejected")
      # This was rejected - so ensure the request gets broadcasted again
      # If the broadcast_status is "Pending", the Notifier will pick it
      # up again in some time and send it out
      self.staffing_request.broadcast_status = "Pending"
      self.staffing_request.save
    end
  end

  def update_dates
  	self.start_date = Time.now if(self.start_code_changed?)
  	self.end_date = Time.now if(self.end_code_changed?)
  end

  validate :check_codes
  def check_codes
    if(self.start_code && self.start_code != self.staffing_request.start_code)
      errors.add(:start_code, "Start Code does not match with the request start code")
    end
    if(self.end_code && self.end_code != self.staffing_request.end_code)
      errors.add(:end_code, "End Code does not match with the request end code")
    end
  end

  def minutes_worked
  	if(self.start_date && self.end_date)
  		minutes = ((self.end_date - self.start_date).to_f / 60).round(0).to_f
  		( minutes / 15).round * 15
  	else
  		0
  	end
  end

end
