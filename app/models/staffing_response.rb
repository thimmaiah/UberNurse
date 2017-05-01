class StaffingResponse < ApplicationRecord
	RESPONSE_STATUS = ["Accepted", "Rejected", "Pending"]
	belongs_to :user
	belongs_to :staffing_request
	belongs_to :hospital
end
