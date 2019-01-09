class Agency < ApplicationRecord
	has_many :agency_user_mappings
	has_many :agency_care_home_mappings
	

	has_many :users, :through => :agency_user_mappings
	has_many :care_homes, :through => :agency_care_home_mappings
end
