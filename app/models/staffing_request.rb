class StaffingRequest < ApplicationRecord

  include StartEndTimeHelper


  acts_as_paranoid
  has_paper_trail ignore: [:pricing_audit]

  after_save ThinkingSphinx::RealTime.callback_for(:staffing_request)

  REQ_STATUS = ["Open", "Closed", "Cancelled"]
  BROADCAST_STATUS =["Sent", "Failed"]
  SHIFT_STATUS =["Not Found", "Found"]

  belongs_to :care_home
  belongs_to :user
  has_many :shifts
  has_one :payment

  # The audit trail of how the price was computed
  serialize :pricing_audit, Hash

  after_save ThinkingSphinx::RealTime.callback_for(:staffing_request)

  scope :open, -> {where(request_status:"Open")}
  scope :closed, -> {where(request_status:"Closed")}
  scope :cancelled, -> {where(request_status:"Cancelled")}
  scope :not_broadcasted, -> {where("broadcast_status <> 'Sent'")}
  scope :current, -> {where("start_date >= ?", Time.now)}

  before_create :set_defaults, :price_estimate

  def set_defaults
    # We now have auto approval
    self.request_status = "Open"
    self.broadcast_status = "Pending"
    self.payment_status = "Unpaid"
    # Zero out the seconds - it causes lots of problems when calculating time spent
    self.start_date = self.start_date.change({sec: 0})
    self.end_date = self.end_date.change({sec: 0})
  end




  def price_estimate
    # Ensure the request gets a price estimate before it is saved
    self.created_at = Time.now
    Rate.price_estimate(self)
  end

  before_save :update_response_status
  def update_response_status
    if( self.request_status_changed? &&
        (self.request_status == 'Closed' || self.request_status == 'Cancelled') )
      # Need to ensure that request whose shift has started cannot be cancelled.
      if(self.request_status == "Cancelled" && self.shifts.last.start_code != nil)
        errors.add(:request_status, "Cannot cancel request when the shift has started.")
      else
        # Ensure all responses are also closed so they dont show up on the UI
        self.shifts.each do |resp|
          resp.response_status = self.request_status
          resp.closed_by_parent_request = true
          resp.save
        end
      end
    end
  end

  def prev_versions
    self.versions.collect(&:reify)
  end

  def booking_start_diff_hrs
    (self.start_date - self.created_at)/(60 * 60)
  end

  def find_care_givers(max_kms_from_care_home, page)
    User.search   :with => {:role => self.role, :active=>true, :verified=>true, :geodist => 0.0..max_kms_from_care_home*1000.0}, 
                  :page=>page, :per_page=>10, 
                  :geo=>[self.care_home.lat * 0.01745329252, self.care_home.lng * 0.01745329252],
                  :order => "geodist ASC"

  end

end
