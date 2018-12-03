class CareHome < ApplicationRecord

  acts_as_paranoid
  after_save ThinkingSphinx::RealTime.callback_for(:care_home)

  has_many :users
  has_many :staffing_requests
  validates_presence_of :name, :postcode
  has_many :ratings, as: :rated_entity

  ZONES = ["North", "South"]

  scope :verified, -> { where verified: true }
  scope :unverified, -> { where verified: false }

  reverse_geocoded_by :lat, :lng do |obj,results|
    if geo = results.first
      obj.address = geo.address.sub(geo.city + ", ", '').sub(geo.postal_code + ", ", '').sub("UK", '') if !obj.address
      obj.town    = geo.city if !obj.town
    end
  end

  def latitude_in_radians
    Math::PI * lat / 180.0 if lat
  end

  def longitude_in_radians
    Math::PI * lng / 180.0 if lng
  end

  before_create :set_defaults
  def set_defaults
    self.verified = false if verified == nil
    self.image_url = "assets/icon/homecare.png"
    self.total_rating = 0
    self.rating_count = 0
    self.manual_assignment_flag = false if self.manual_assignment_flag == nil
  end

  after_create :send_verification_mail
  def send_verification_mail
    if(!self.verified && self.users.admins.active.length > 0)
      self.users.admins.active.each do |admin|
        UserNotifierMailer.verify_care_home(self, admin).deliver_later
      end
    end
  end


  after_save :update_coordinates
  def update_coordinates
    if(self.postcode_changed? && Rails.env != "test")
      GeocodeJob.perform_later(self)
    end
  end

  after_save :care_home_verified
  def care_home_verified
    if(self.verified_changed? && self.verified)
      UserNotifierMailer.care_home_verified(self).deliver_later
    end
  end

  before_save :check_accept_bank_transactions
  def check_accept_bank_transactions
    if(self.accept_bank_transactions && self.accept_bank_transactions_changed?)
      self.accept_bank_transactions_date = Time.now
    end
  end


  # for testing only in factories - do not use in prod
  def postcodelatlng=(postcodelatlng)
    self.postcode = postcodelatlng.postcode
    self.lat = postcodelatlng.latitude
    self.lng = postcodelatlng.longitude
  end

  def preferred_care_givers
    if(self.preferred_care_giver_ids)
      pref_care_giver_ids = self.preferred_care_giver_ids.split(",").map{|id| id.strip.to_i}
      User.order("auto_selected_date ASC").find(pref_care_giver_ids)
    end
  end

end
