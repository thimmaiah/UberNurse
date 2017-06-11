class PaymentSerializer < ActiveModel::Serializer
  attributes :id, :shift_id, :user_id, :care_home_id, 
  :paid_by_id, :amount, :notes, :user, :care_home, :staffing_request_id, :staffing_request
end
