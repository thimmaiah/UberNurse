class Rating < ApplicationRecord
	
	COMMENTS = ["Great Work", "Good Work", "Not Bad", "Can Improve"]
	
	belongs_to :staffing_response
	belongs_to :user
	belongs_to :created_by, class_name: "User", foreign_key: :created_by_id
	
end
