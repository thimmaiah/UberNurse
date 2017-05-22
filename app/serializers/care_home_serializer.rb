class CareHomeSerializer < ActiveModel::Serializer
  attributes :id, :name, :address, :town, :postcode, :base_rate, :can_manage, :image_url, :verified
  def can_manage
  	Ability.new(scope).can?(:manage, object)
  end
end
