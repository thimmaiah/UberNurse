class Profile < ApplicationRecord

	belongs_to :agency
	belongs_to :user
	has_many :trainings

	validates_presence_of :user_id, :form_completed_by, :role, :position, :agency_id

	scope :by_agency, lambda { |agency_id|
	    return scoped unless agency_id.present?
	    where(:agency_id => agency_id)
	}

end
