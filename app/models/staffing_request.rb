class StaffingRequest < ApplicationRecord

  include StartEndTimeHelper


  acts_as_paranoid
  has_paper_trail ignore: [:pricing_audit]

  after_save ThinkingSphinx::RealTime.callback_for(:staffing_request)

  REQ_STATUS = ["Open", "Closed", "Cancelled"]
  BROADCAST_STATUS =["Sent", "Failed"]
  SHIFT_STATUS =["Not Found", "Found"]

  belongs_to :agency
  belongs_to :care_home
  belongs_to :user
  has_many :shifts
  has_one :payment

  has_one :accepted_shift, -> { where(response_status:["Accepted", "Closed"]) }, :class_name => 'Shift' 
  has_one :assigned_shift, -> { where(response_status:["Accepted", "Closed", "Pending"]) }, :class_name => 'Shift' 

  belongs_to :recurring_request

  validates_presence_of :user_id, :care_home_id, :agency_id, :start_date, :end_date, :role

  # The audit trail of how the price was computed
  serialize :pricing_audit, Hash
  serialize :select_user_audit, Hash

  after_save ThinkingSphinx::RealTime.callback_for(:staffing_request)

  scope :open, -> {where(request_status:"Open")}
  scope :not_found, -> {where(shift_status:"Not Found")}
  scope :closed, -> {where(request_status:"Closed")}
  scope :cancelled, -> {where(request_status:"Cancelled")}
  scope :not_cancelled, -> {where("request_status <> 'Cancelled'")}
  scope :not_broadcasted, -> {where("broadcast_status <> 'Sent'")}
  scope :current, -> {where("start_date >= ?", Time.now)}
  scope :not_manual_assignment, -> {where("manual_assignment_flag = ?", false)}
  scope :manual_assignment, -> {where("manual_assignment_flag = ?", true)}

  before_create :set_defaults, :price_estimate
  after_create :send_admin_notification

  def set_defaults
    # We now have auto approval
    self.request_status = "Open"
    self.broadcast_status = "Pending"
    self.payment_status = "Unpaid"
    
    # Zero out the seconds - it causes lots of problems when calculating time spent
    self.start_date = self.start_date.change({sec: 0})
    self.end_date = self.end_date.change({sec: 0})

    # Copy over the manual_assignment_flag from the care_home
    self.manual_assignment_flag = self.agency_care_home_mapping.manual_assignment_flag if self.manual_assignment_flag == nil 
    self.manual_assignment_flag = false if self.manual_assignment_flag == nil

    
    if self.speciality == nil
      if self.care_home.speciality != nil
        # Some care homes have a default speciality
        self.speciality = self.care_home.speciality 
      else  
        # Ask for a Generalist if the speciality is not set
        self.speciality = "Generalist" 
      end
    end
  end




  def price_estimate
    # Ensure the request gets a price estimate before it is saved
    self.created_at = Time.now
    Rate.price_estimate(self)
  end

  def send_admin_notification
    UserNotifierMailer.staffing_request_created(self).deliver_later
  end

  before_save :update_response_status
  def update_response_status
    if( self.request_status_changed? &&
        (self.request_status == 'Closed' || self.request_status == 'Cancelled') )
      # Need to ensure that request whose shift has started cannot be cancelled.
      if(self.request_status == "Cancelled" && self.shifts.last && self.shifts.last.start_code != nil)
        errors.add(:request_status, "Cannot cancel request when the shift has started.")
      else
        # Ensure all responses are also closed so they dont show up on the UI
        self.shifts.open.each do |resp|
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

  def preferred_carer
    User.find(preferred_carer_id) if preferred_carer_id
  end

  def agency_care_home_mapping
    AgencyCareHomeMapping.where(agency_id: self.agency_id, care_home_id: self.care_home_id).first    
  end

  # Need to find the preferred care givers for this care home for this agency
  def preferred_care_givers
    acm = agency_care_home_mapping
    if acm.preferred_care_giver_ids
      pref_care_giver_ids = acm.preferred_care_giver_ids.split(",").map{|id| id.strip.to_i}
      User.order("auto_selected_date ASC").find(pref_care_giver_ids)
    end
  end

  def limit_shift_to_pref_carer
    acm = agency_care_home_mapping
    acm.limit_shift_to_pref_carer
  end
  
end
