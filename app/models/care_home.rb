class CareHome < ApplicationRecord

  acts_as_paranoid
  after_save ThinkingSphinx::RealTime.callback_for(:care_home)

  has_many :users
  has_many :staffing_requests
  validates_presence_of :name, :postcode

  ZONES = ["North", "South"]

  scope :verified, -> { where verified: true }

  reverse_geocoded_by :lat, :lng do |obj,results|
    if geo = results.first
      obj.address = geo.address.sub(geo.city + ", ", '').sub(geo.postal_code + ", ", '').sub("UK", '') if !obj.address
      obj.town    = geo.city if !obj.town
    end
  end

  before_create :set_defaults
  def set_defaults
    self.verified = false
  end

  after_create :send_verification_mail
  def send_verification_mail
    if(!self.verified && self.users.admins.active.length > 0)
      self.users.admins.active.each do |admin|
        UserNotifierMailer.verify_care_home(admin).deliver_later
      end
    end
  end


  after_save :update_coordinates
  def update_coordinates
    if(self.postcode_changed?)
      GeocodeJob.perform_later(self)
    end
  end

  after_save :care_home_verified
  def care_home_verified
    if(self.verified_changed? && self.verified)
      UserNotifierMailer.care_home_verified(self).deliver_later
    end
  end

end
