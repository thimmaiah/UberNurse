class AgencyUserMapping < ApplicationRecord
  validates_presence_of :agency_id, :user_id
  belongs_to :agency
  belongs_to :user

  scope :verified, -> { where(verified: true) }

  before_save :update_user
  validate :check_accepted

  def check_accepted
    if self.verified && self.verified_changed? && !self.accepted
      errors.add(:verified, "Cannot be verified till Care Home accepts. Please get the care home to accept you as the Agency")
      puts errors
    end
  end


  def update_user
  	if self.verified && !errors
  		self.user.verified = true
      self.user.verified_on = Date.today
  		self.user.save
      UserNotifierMailer.verification_complete(self.id).deliver_later if self.id
  	end
  end

end
