class Hospital < ApplicationRecord
	has_many :users
	has_many :staffing_requests
end
