class Payment < ApplicationRecord
	belongs_to :user
	belongs_to :hospital
	belongs_to :staffing_response
	belongs_to :staffing_request
	belongs_to :paid_by, class_name: "User", foreign_key: :paid_by_id	
end
