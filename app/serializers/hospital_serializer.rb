class HospitalSerializer < ActiveModel::Serializer
  attributes :id, :name, :address, :street, :locality, :town, :postcode, :base_rate
end
