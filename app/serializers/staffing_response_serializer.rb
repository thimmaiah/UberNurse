class StaffingResponseSerializer < ActiveModel::Serializer
  attributes :id, :staffing_request_id, :user_id, :start_code, :end_code, :response_status, 
  :accepted, :rated, :user, :can_manage

  belongs_to :user, serializer: UserMiniSerializer
  
  def can_manage
  	Ability.new(scope).can?(:manage, object)
  end
end
