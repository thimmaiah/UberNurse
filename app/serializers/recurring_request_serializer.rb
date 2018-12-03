class RecurringRequestSerializer < ActiveModel::Serializer
  attributes :id, :care_home_id, :user_id, :start_date, :end_date, :role, :speciality, :on, :start_on, :end_on, :audit
end
