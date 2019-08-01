class CareHomeCarerMapping < ApplicationRecord
	belongs_to :care_home
	belongs_to :user	


	before_save :compute_distance

	def compute_distance
		self.distance = self.user.distance_from(self.care_home)
	end

	def self.populate_carers_from_history
		Shift.closed.each do |s|
			exiting = CareHomeCarerMapping.where(care_home_id: s.care_home_id, user_id: s.user_id).first
			if exiting == nil
				ccm = CareHomeCarerMapping.create(care_home_id: s.care_home_id, user_id: s.user_id, enabled: true, agency_id: s.agency_id) 
				Rails.logger.debug "Creating CareHomeCarerMapping from history #{ccm.id}"
			end
		end
	end

end
