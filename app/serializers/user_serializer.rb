class UserSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :email, :role, :nurse_type, 
  :sex, :phone, :address, :languages, :pref_commute_distance, 
  :occupation, :speciality, :experience, :referal_code, :accept_terms, :hospital_id
end
