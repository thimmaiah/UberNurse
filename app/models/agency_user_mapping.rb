
class AgencyUserMapping < ApplicationRecord
  validates_presence_of :agency_id, :user_id
  belongs_to :agency
  belongs_to :user

  scope :verified, -> { where(verified: true) }
  scope :not_accepted, -> { where(accepted: false) }

  after_save ThinkingSphinx::RealTime.callback_for(:agency_user_mapping)
  before_create :set_defaults
  before_save :update_user
  validate :check_accepted
  after_create :send_user_accept_notification

  def check_accepted
    if self.verified && self.verified_changed? && !self.accepted
      errors.add(:verified, "Cannot be verified till Care Home accepts. Please get the care home to accept you as the Agency")
      puts errors
    end
  end

  def set_defaults
    self.verified = false if self.verified == nil
    self.accepted = false if self.accepted == nil
    self.accepted = true  
  end

  def update_user    
  	if self.verified && self.verified_changed?
  		self.user.verified = true
      self.user.verified_on = Date.today
  		self.user.save      
      UserNotifierMailer.verification_complete(self.id).deliver_later if self.id && self.user.is_temp?
    else
      self.user.care_home_carer_mappings.update_all(agency_id: self.agency_id, enabled: false)
  	end
  end

  def send_user_accept_notification
    UserNotifierMailer.user_accept_agency_notification(self).deliver_later unless self.accepted
  end

end
