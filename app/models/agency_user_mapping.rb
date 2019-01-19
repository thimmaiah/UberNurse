class AgencyUserMapping < ApplicationRecord
  validates_presence_of :agency_id, :user_id
  belongs_to :agency
  belongs_to :user

  scope :verified, -> { where(verified: true) }

  after_save :update_user

  def update_user
  	if self.verified
  		self.user.verified = true
      self.user.verified_on = Date.today
  		self.user.save
      UserNotifierMailer.verification_complete(self.id).deliver_later if self.id
  	end
  end

end
