class StaffingRequest < ApplicationRecord
	REQ_STATUS = ["Pending Approval", "Approved", "Denied", "Closed"]
	belongs_to :hospital
	belongs_to :user
	has_many :staffing_responses

	before_create :set_codes

	def set_codes
		self.start_code = rand.to_s[2..6]
		self.end_code = rand.to_s[2..6]
	end
end
