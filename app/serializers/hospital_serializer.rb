class HospitalSerializer < ActiveModel::Serializer
  attributes :id, :name, :address, :street, :locality, :town, :postcode, :base_rate, :can_manage
  def can_manage
  	Ability.new(scope).can?(:manage, object)
  end
end
