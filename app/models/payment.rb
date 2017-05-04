class Payment < ApplicationRecord
	belongs_to :user
	belongs_to :hospital
	belongs_to :staffing_response
	belongs_to :staffing_request
	belongs_to :paid_by, class_name: "User", foreign_key: :paid_by_id	

	after_create :update_payment_status
	before_destroy :revert_payment_status

	def update_payment_status
		self.staffing_response.payment_status = "Paid"
		self.staffing_response.save
	end

	def revert_payment_status
		self.staffing_response.payment_status = nil
		self.staffing_response.save
	end
end
