class AgencyCareHomeMapping < ApplicationRecord
  validates_presence_of :agency_id, :care_home_id
  belongs_to :agency
  belongs_to :care_home

  before_save :update_care_home

  def update_care_home
  	if self.verified
  		self.care_home.verified = true
  		self.care_home.save
      UserNotifierMailer.care_home_verified(self.id).deliver_later
  	end
  end
end
