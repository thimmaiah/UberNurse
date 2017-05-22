class StaffingResponseMiniSerializer < ActiveModel::Serializer
  attributes :id, :staffing_request_id, :user_id, :start_code, :start_date, 
  :end_code, :end_date, :response_status, :minutes_worked,
  :accepted, :rated, :user, :care_home, :staffing_request, :payment_status, :can_manage

  belongs_to :user, serializer: UserMiniSerializer
  
  def can_manage
  	Ability.new(scope).can?(:manage, object)
  end
end
