class AgencyCareHomeMapping < ApplicationRecord
  belongs_to :agency
  belongs_to :care_home
end
