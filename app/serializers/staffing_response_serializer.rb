class StaffingResponseSerializer < ActiveModel::Serializer
  attributes :id, :staffing_request_id, :user_id, :start_code, :end_code, :response_status, 
  :accepted, :rated, :user
  belongs_to :user, serializer: UserMiniSerializer
end
