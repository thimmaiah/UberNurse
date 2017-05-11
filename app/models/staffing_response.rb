class StaffingResponse < ApplicationRecord

	acts_as_paranoid
	
	RESPONSE_STATUS = ["Accepted", "Rejected", "Pending"]
	belongs_to :user
	belongs_to :staffing_request
	belongs_to :hospital
	has_one :payment
	has_one :rating

	scope :not_rejected, -> {where("response_status <> 'Rejected'")}
	scope :accepted, -> {where("response_status = 'Accepted'")}

	before_save :process_rejected

	def process_rejected
		if(self.response_status_changed? && self.response_status == "Rejected")
			# This was rejected - so ensure the request gets broadcasted again
			# If the broadcast_status is "Pending", the Notifier will pick it 
			# up again in some time and send it out
			self.staffing_request.broadcast_status = "Pending"
			self.staffing_request.save
		end
	end
end
