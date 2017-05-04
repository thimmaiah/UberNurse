class PaymentSerializer < ActiveModel::Serializer
  attributes :id, :staffing_response_id, :user_id, :hospital_id, 
  :paid_by_id, :amount, :notes, :user, :hospital, :staffing_request_id, :staffing_request
end
