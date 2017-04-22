class UserMiniSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :email, :role, :phone, :speciality
end
