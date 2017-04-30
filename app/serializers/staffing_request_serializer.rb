class StaffingRequestSerializer < ActiveModel::Serializer
  
  

  attributes :id, :hospital_id, :user_id, :start_date, :end_date, :rate_per_hour, 
  :request_status, :auto_deny_in, :response_count, :payment_status, :user, :hospital, :broadcast_status, :can_manage

  attribute :staffing_responses

  belongs_to :user, serializer: UserMiniSerializer

  def can_manage
  	ability = Ability.new(scope)
  	ability.can?(:manage, object)
  end

end
