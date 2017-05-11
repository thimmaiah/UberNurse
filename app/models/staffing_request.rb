class StaffingRequest < ApplicationRecord

	acts_as_paranoid
	
	REQ_STATUS = ["Open", "Closed"]
	BROADCAST_STATUS =["Sent", "Failed"]

	belongs_to :hospital
	belongs_to :user
	has_many :staffing_responses
	has_one :payment

	#after_save ThinkingSphinx::RealTime.callback_for(:staffing_request)

	scope :open, -> {where(request_status:"Open")}
	scope :closed, -> {where(request_status:"Closed")}
	scope :not_broadcasted, -> {where("broadcast_status <> 'Sent' OR broadcast_status is null")}

	before_create :open_request

	def open_request
		# We now have auto approval
		self.request_status = "Open"
	end
	
end
