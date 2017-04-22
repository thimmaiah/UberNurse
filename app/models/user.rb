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

end
