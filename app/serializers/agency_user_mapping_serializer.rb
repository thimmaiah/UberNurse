class AgencyUserMappingSerializer < ActiveModel::Serializer
  attributes :id
  has_one :agency
  has_one :user
end
