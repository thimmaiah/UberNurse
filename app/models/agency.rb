class Agency < ApplicationRecord
	has_many :agency_user_mappings
	has_many :agency_care_home_mappings
		

	has_many :users, :through => :agency_user_mappings
	has_many  :verified_users, -> { where agency_user_mappings: { verified: true } }, 
		  :through => :agency_user_mappings,
          :class_name => "User", 
          :source => :user 
          


	has_many :care_homes, :through => :agency_care_home_mappings
	has_many  :verified_care_homes, -> { where agency_care_home_mappings: { verified: true } }, 
		  :through => :agency_care_home_mappings,
          :class_name => "CareHome", 
          :source => :care_home 
    

    def emails
    	list = User.where(agency_id:self.id).collect(&:email).join(",")
    	if(self.broadcast_group)
    		list += "," + self.broadcast_group
    	end
    	list
    end
end
