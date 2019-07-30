class CareHomeCarerMapping < ApplicationRecord
	belongs_to :care_home
	belongs_to :user	
end
