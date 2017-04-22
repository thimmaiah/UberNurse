class StaffingRequest < ApplicationRecord
	REQ_STATUS = ["Pending Approval", "Approved", "UnApproved", "Closed"]
	belongs_to :hospital
	belongs_to :user
	has_many :staffing_responses
end
