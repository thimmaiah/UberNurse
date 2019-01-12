class RateSerializer < ActiveModel::Serializer
  attributes :id, :zone, :role, :speciality, :amount
  has_one :agency, serializer: AgencySerializer
end
