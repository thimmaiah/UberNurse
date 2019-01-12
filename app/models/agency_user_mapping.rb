class AgencyUserMapping < ApplicationRecord
  validates_presence_of :agency_id, :user_id
  belongs_to :agency
  belongs_to :user
end
