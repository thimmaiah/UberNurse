class AgencyCareHomeMapping < ApplicationRecord
  validates_presence_of :agency_id, :care_home_id
  belongs_to :agency
  belongs_to :care_home

  before_save :update_care_home
  validate :check_accepted

  def check_accepted
    if self.verified && self.verified_changed? && !self.accepted
      errors.add(:verified, "Cannot be verified till Care Home accepts. Please get the care home to accept you as the Agency")
      puts errors
    end
  end

  def update_care_home
  
  	if self.verified && !errors
  		self.care_home.verified = true
  		self.care_home.save
      UserNotifierMailer.care_home_verified(self.id).deliver_later
  	end
  end
end
