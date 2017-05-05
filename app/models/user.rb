class User < ApplicationRecord
  belongs_to :hospital, optional: true
  has_many :staffing_requests
  has_many :staffing_responses
  has_many :user_docs

  SEX = ["M", "F"]
  SPECIALITY = ["Geriatric Care", "Pediatric Care", "Trauma"]
  ROLE =["Care Giver", "Employee", "Admin"]

  
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable,
          :confirmable, :omniauthable
  include DeviseTokenAuth::Concerns::User


  scope :care_givers, -> { where role: "Care Giver" }
  scope :verified, -> { where verified: true }
  scope :admins, ->(hospital_id){ where role: "Admin", hospital_id: hospital_id }
  scope :employees, ->(hospital_id) { where role: "Employee", hospital_id: hospital_id }


  def self.guest
    u = User.new
    u.role = "Guest"
    u.first_name = "Guest"
    u.last_name = "User"
    u.email = "guest.user@ubernurse.com"
    u.active = true
  
    return u
  end

  def image
    self.image_url ? self.image_url : "http://www.iconshock.com/img_vista/IPHONE/jobs/jpg/nurse_icon.jpg"
  end
end
