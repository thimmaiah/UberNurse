class StaffingRequest < ApplicationRecord
	REQ_STATUS = ["Pending Approval", "Approved", "Denied", "Closed"]
	BROADCAST_STATUS =["Sent", "Failed"]

	belongs_to :hospital
	belongs_to :user
	has_many :staffing_responses

	after_save ThinkingSphinx::RealTime.callback_for(:staffing_request)

	scope :approved, -> {where(request_status:"Approved")}
	scope :not_broadcasted, -> {where("broadcast_status <> 'Sent' OR broadcast_status is null")}

end
