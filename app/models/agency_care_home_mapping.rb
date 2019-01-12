class AgencyCareHomeMapping < ApplicationRecord
  validates_presence_of :agency_id, :care_home_id
  belongs_to :agency
  belongs_to :care_home
end
