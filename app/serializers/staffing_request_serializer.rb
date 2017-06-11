class StaffingRequestSerializer < ActiveModel::Serializer
  
  

  attributes :id, :care_home_id, :user_id, :start_date, :end_date, :rate_per_hour, :role, :speciality,
  :request_status, :auto_deny_in, :response_count, :payment_status, :user, :care_home, 
  :broadcast_status, :can_manage, :start_code, :end_code, :price, :pricing_audit, :created_at, :updated_at

  attribute :shifts

  belongs_to :user, serializer: UserMiniSerializer

  def can_manage
  	ability = Ability.new(scope)
  	ability.can?(:manage, object)
  end

end
