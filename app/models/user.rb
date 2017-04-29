class User < ApplicationRecord
  
  SEX = ["M", "F"]
  SPECIALITY = ["Geriatric Care", "Pediatric Care", "Trauma"]
  ROLE =["Care Giver", "Employee", "Admin"]

  belongs_to :hospital, optional: true

  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable,
          :confirmable, :omniauthable
  include DeviseTokenAuth::Concerns::User


  scope :care_givers, -> { where role: "Care Giver" }

  def self.guest
    u = User.new
    u.role = "Guest"
    u.first_name = "Guest"
    u.last_name = "User"
    u.email = "guest.user@ubernurse.com"
    u.active = true
  
    return u
  end

end
