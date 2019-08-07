class CareHomeCarerMapping < ApplicationRecord
	belongs_to :care_home
	belongs_to :user	


	before_save :compute_distance
	before_save :set_defaults

	scope :enabled, -> { where enabled: true }
	scope :preferred, -> { where preferred: true }
	scope :agency_filter, -> (agency_id) { where('care_home_carer_mappings.enabled=? and care_home_carer_mappings.agency_id = ?', true, agency_id) }


	def set_defaults
		self.enabled = false if self.enabled == nil
		self.preferred = false if self.preferred == nil
	end

	def compute_distance
		self.distance = self.user.distance_from(self.care_home) if self.user
	end

	def self.populate_carers_from_history

		AgencyCareHomeMapping.all.each do |s|
			if(s.preferred_care_giver_ids)
				s.preferred_care_giver_ids.split(",").each do |user_id|
					exiting = CareHomeCarerMapping.where(care_home_id: s.care_home_id, user_id: user_id).first
					if exiting == nil
						ccm = CareHomeCarerMapping.create(care_home_id: s.care_home_id, user_id: user_id, 
														  enabled: true, agency_id: s.agency_id, preferred: true) 
						Rails.logger.debug "Creating CareHomeCarerMapping from history #{ccm.id}"
					end	
				end
			end
		end

		Shift.closed.each do |s|
			exiting = CareHomeCarerMapping.where(care_home_id: s.care_home_id, user_id: s.user_id).first
			if exiting == nil
				ccm = CareHomeCarerMapping.create(care_home_id: s.care_home_id, user_id: s.user_id, 
					                              enabled: true, agency_id: s.agency_id, preferred: false) 
				Rails.logger.debug "Creating CareHomeCarerMapping from history #{ccm.id}"
			end
		end

	end

end
