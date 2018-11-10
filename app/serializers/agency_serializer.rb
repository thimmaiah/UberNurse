class AgencySerializer < ActiveModel::Serializer
  attributes :id, :name, :broadcast_group, :address, :postcode, :phone
end
