class AgencyCareHomeMappingSerializer < ActiveModel::Serializer
  attributes :id, :care_home, :agency, :can_manage, :accepted, :verified	

  has_one :agency
  has_one :care_home

  def can_manage
  	Ability.new(scope).can?(:manage, object)
  end
end
