class UserSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :email, :role, :nurse_type, 
  :sex, :phone, :address, :languages, :pref_commute_distance, 
  :occupation, :speciality, :experience, :referal_code, :accept_terms, :hospital_id,
  :image, :can_manage

  def can_manage
  	Ability.new(scope).can?(:manage, object)
  end
end
