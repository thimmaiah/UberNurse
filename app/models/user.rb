class User < ApplicationRecord

  acts_as_paranoid
  after_save ThinkingSphinx::RealTime.callback_for(:user)

  validates_presence_of :first_name, :last_name, :email, :role, :postcode, :phone

  belongs_to :care_home, optional: true
  has_many :staffing_requests
  has_many :staffing_responses
  has_many :user_docs, -> { order(:verified=>:desc) }
  has_one :profile_pic, -> { where(doc_type: "Profile Pic") }, class_name: "UserDoc"

  SEX = ["M", "F"]
  SPECIALITY = ["Generalist", "Geriatric Care", "Pediatric Care", "Mental Health"]
  ROLE =["Care Giver", "Nurse", "Admin"]


  # Include default devise modules.
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable,
    :confirmable, :omniauthable

  include DeviseTokenAuth::Concerns::User


  scope :care_givers, -> { where role: "Care Giver" }
  scope :nurses, -> { where role: "Nurse" }
  scope :admins, -> { where role: "Admin"}
  scope :temps, -> { where "role = ? or role = ?", "Care Giver", "Nurse"}
  scope :verified, -> { where verified: true }
  scope :active, -> { where active: true }

  after_save :update_coordinates
  before_save :check_verified
  before_create :update_rating
  before_create :add_unsubscribe_hash
  reverse_geocoded_by :lat, :lng


  def add_unsubscribe_hash
    self.unsubscribe_hash = SecureRandom.hex
    self.subscription = true
  end

  def check_verified
    if(self.verified_changed? && self.verified)
      self.verified_on = Date.today
      UserNotifierMailer.verification_complete(self.id).deliver_later
    end
  end
  
  def update_coordinates
    if(self.postcode_changed?)
      GeocodeJob.perform_later(self)
    end
  end

  def is_temp?
    self.role == "Care Giver" || self.role == "Nurse"
  end

  def update_rating
    self.total_rating = 0
    self.rating_count = 0
    self.active = true
    if(self.is_temp? && self.verified == nil)
      self.verified = false
    end
  end

  def self.guest
    u = User.new
    u.role = "Guest"
    u.first_name = "Guest"
    u.last_name = "User"
    u.email = "guest.user@ubernurse.com"
    u.active = true

    return u
  end

  def verifiable_docs
    self.user_docs.not_rejected.not_expired
  end

  def image
    self.image_url ? self.image_url : "http://www.iconshock.com/img_vista/IPHONE/jobs/jpg/nurse_icon.jpg"
  end

  def token_validation_response                                                                                                                                         
    UserSerializer.new(self).as_json
  end

  # for testing only in factories - do not use in prod
  def postcodelatlng=(postcodelatlng)
    self.postcode = postcodelatlng.postcode
    self.lat = postcodelatlng.latitude
    self.lng = postcodelatlng.longitude
  end
end
