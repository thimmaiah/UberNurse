class AgencyUserMappingSerializer < ActiveModel::Serializer
  attributes :id, :can_manage, :agency, :user, :accepted, :verified

  has_one :agency
  has_one :user

  def can_manage
  	Ability.new(scope).can?(:manage, object)
  end

end
