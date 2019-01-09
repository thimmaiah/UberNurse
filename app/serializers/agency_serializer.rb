class AgencySerializer < ActiveModel::Serializer
  attributes :id, :name, :address, :postcode, :phone, :broadcast_group
end
