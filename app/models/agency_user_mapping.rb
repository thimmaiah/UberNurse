class AgencyUserMapping < ApplicationRecord
  validates_presence_of :agency_id, :user_id
  belongs_to :agency
  belongs_to :user

  before_save :update_user

  def update_user
  	if self.verified
  		self.user.verified = true
  		self.user.save
  	end
  end

end
