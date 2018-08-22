class User < ApplicationRecord

  acts_as_paranoid
  after_save :index_user
  has_paper_trail ignore: [:sign_in_count, :current_sign_in_at, :last_sign_in_at, :current_sign_in_ip, :last_sign_in_ip, :tokens]

  validates_presence_of :first_name, :last_name, :email, :role, :phone

  belongs_to :care_home, optional: true
  has_many :staffing_requests
  has_many :shifts
  has_many :payments
  has_many :user_docs, -> { order(:verified=>:desc) }
  has_one :profile_pic, -> { where(doc_type: "Profile Pic") }, class_name: "UserDoc"
  has_many :ratings, as: :rated_entity

  SEX = ["M", "F"]
  SPECIALITY = ["Generalist", "Geriatric Care", "Pediatric Care", "Mental Health"]
  ROLE = ["Care Giver", "Nurse", "Admin"]
  TITLE = ["Mr", "Mrs", "Miss"]


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
  before_save :check_accept_bank_transactions
  before_create :set_defaults
  before_create :add_unsubscribe_hash
  reverse_geocoded_by :lat, :lng

  def index_user
    # This is to avoid the user being indexed with every request
    # as with this API app the user tokens get updated with every request due to device

    #logger.debug "index_user #{self.changed}"
    if( self.changed.length == 2 && self.changed[0] == "tokens" && self.changed[1] == "updated_at" )
      return
    else
      ThinkingSphinx::RealTime::Callbacks::RealTimeCallbacks.new(
        :user
      ).after_save self
    end

  end

  def latitude_in_radians
    Math::PI * lat / 180.0 if lat
  end

  def longitude_in_radians
    Math::PI * lng / 180.0 if lng
  end


  def add_unsubscribe_hash
    self.unsubscribe_hash = SecureRandom.hex
    self.subscription = true
  end

  def check_accept_bank_transactions
    if(self.accept_bank_transactions && self.accept_bank_transactions_changed?)
      self.accept_bank_transactions_date = Time.now
    end
  end

  def check_verified
    if(self.verified_changed? && self.verified)
      self.verified_on = Date.today
      UserNotifierMailer.verification_complete(self.id).deliver_later if self.id
    end
  end

  def update_coordinates
    if(self.postcode && self.postcode_changed? && Rails.env != "test")
      GeocodeJob.perform_later(self)
    end
  end

  def is_temp?
    self.role == "Care Giver" || self.role == "Nurse"
  end

  def set_defaults
    self.total_rating = 0
    self.rating_count = 0
    self.active = true

    if(self.is_temp? && self.verified == nil)
      self.verified = false
    end
    
    # Default the speciality
    if(self.is_temp? && self.speciality == nil)
      self.speciality = "Generalist"
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
    if(self.image_url)
      return self.image_url
    elsif self.profile_pic
      self.profile_pic.doc_url
    else
      return "http://www.iconshock.com/img_vista/IPHONE/jobs/jpg/nurse_icon.jpg"
    end
  end

  def token_validation_response
    UserSerializer.new(self).as_json
  end

  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end

  def send_sms_verification
    self.sms_verification_code = rand.to_s[2..6]
    self.save
    msg = "Your Connect Care phone verification code is: #{self.sms_verification_code}"
    send_sms(msg)
  end


  def send_sms(msg)
    to_phone = self.phone
    from_phone = ENV['TWILIO_NUMBER']

    if(Rails.env != 'test' && ENV["SEND_SMS"] == 'true')
      logger.debug "Sending sms '#{msg}' to #{self.email} @ #{to_phone} from #{from_phone}"

      twilio = Twilio::REST::Client.new(ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN'])
      twilio.messages.create(
        from: from_phone,
        to: to_phone,
        body: msg
      )
      true
    else
      logger.debug "Not sending sms '#{msg}' to #{self.email} @ #{to_phone} from #{from_phone}. ENV['SEND_SMS'] = #{ENV['SEND_SMS']} & Rails.env = #{Rails.env}"
      false
    end


  end


  def confirm_sms_verification(code)
    self.phone_verified = (code == self.sms_verification_code)
    self.save
    return self.phone_verified
  end

  def mins_worked_in_month(date=Date.today)
    som = date.beginning_of_month
    eom = date.end_of_month
    month_shifts = self.shifts.joins(:staffing_request).where("staffing_requests.start_date >= ? and staffing_requests.start_date < ?", som, eom + 1.day)
    month_total_mins_worked = month_shifts.sum(:total_mins_worked)
    month_total_mins_worked
  end

  # for testing only in factories - do not use in prod
  def postcodelatlng=(postcodelatlng)
    self.postcode = postcodelatlng.postcode
    self.lat = postcodelatlng.latitude
    self.lng = postcodelatlng.longitude
  end
end
