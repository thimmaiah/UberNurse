class UserMiniSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :email, :role, :phone, :speciality, :can_manage
  def can_manage
  	Ability.new(scope).can?(:manage, object)
  end
end
