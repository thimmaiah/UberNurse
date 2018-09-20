class Profile < ApplicationRecord
	belongs_to :user
	has_many :trainings
end
