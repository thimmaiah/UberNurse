class Reference < ApplicationRecord
	TYPES = ["Current Employer", "Past Employer", "Charecter Reference"]
	belongs_to :user
end
