class AgencyCareHomeMapping < ApplicationRecord
	belongs_to :care_home
	belongs_to :agency
end
