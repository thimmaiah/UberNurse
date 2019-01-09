class AgencyCareHomeMappingSerializer < ActiveModel::Serializer
  attributes :id
  has_one :agency
  has_one :care_home
end
