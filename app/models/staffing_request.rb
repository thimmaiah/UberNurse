class StaffingRequest < ApplicationRecord

  acts_as_paranoid
  has_paper_trail
  after_save ThinkingSphinx::RealTime.callback_for(:staffing_request)

  REQ_STATUS = ["Open", "Closed"]
  BROADCAST_STATUS =["Sent", "Failed"]

  belongs_to :care_home
  belongs_to :user
  has_many :staffing_responses
  has_one :payment

  #after_save ThinkingSphinx::RealTime.callback_for(:staffing_request)

  scope :open, -> {where(request_status:"Open")}
  scope :closed, -> {where(request_status:"Closed")}
  scope :not_broadcasted, -> {where("broadcast_status <> 'Sent'")}

  before_create :set_defaults

  def set_defaults
    # We now have auto approval
    self.request_status = "Open"
    self.broadcast_status = "Pending"
    self.payment_status = "Unpaid"
  end

  before_save :update_response_status
  def update_response_status
    if( self.request_status_changed? && self.request_status == 'Closed')
    	# Ensure all responses are also closed so they dont show up on the UI
      self.staffing_responses.each do |resp|	
        resp.response_status = "Closed"
        resp.save
      end
    end
  end

  def prev_versions
  	self.versions.collect(&:reify)
  end

  def booking_start_diff_hrs
    (self.start_date - self.created_at)/(60 * 60)
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
