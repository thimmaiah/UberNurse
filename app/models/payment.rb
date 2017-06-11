class Payment < ApplicationRecord

	acts_as_paranoid
	after_save ThinkingSphinx::RealTime.callback_for(:payment)
	
	belongs_to :user
	belongs_to :care_home
	belongs_to :shift
	belongs_to :staffing_request
	belongs_to :paid_by, class_name: "User", foreign_key: :paid_by_id	

	after_create :update_payment_status
	before_destroy :revert_payment_status

	def update_payment_status
		self.shift.payment_status = "Paid"
		self.shift.save
	end

	def revert_payment_status
		self.shift.payment_status = nil
		self.shift.save
	end
end
