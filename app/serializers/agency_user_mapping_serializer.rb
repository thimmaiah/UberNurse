class AgencyUserMappingSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :agency_id
end
