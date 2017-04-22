class StaffingRequestSerializer < ActiveModel::Serializer
  attributes :id, :hospital_id, :user_id, :start_date, :end_date, :rate_per_hour, 
  :request_status, :auto_deny_in, :response_count, :payment_status, :user, :hospital
end
