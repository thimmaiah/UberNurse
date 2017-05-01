class StaffingResponse < ApplicationRecord
	RESPONSE_STATUS = ["Accepted", "Rejected", "Pending"]
	belongs_to :user
	belongs_to :staffing_request
	belongs_to :hospital

	scope :not_rejected, -> {where("response_status <> 'Rejected'")}
end
