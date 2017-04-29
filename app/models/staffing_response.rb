class StaffingResponse < ApplicationRecord
	belongs_to :user
	belongs_to :staffing_request
	belongs_to :hospital
end
