class HiringRequest < ApplicationRecord
	belongs_to :user
	belongs_to :hospital
	has_many :hiring_responses
end
