class HiringRequestSerializer < ActiveModel::Serializer
  attributes :id, :start_date, :start_time, :end_date, :num_of_hours, :rate, :req_type, :user_id, :hospital_id
  belongs_to :user
  belongs_to :hospital
  has_many :hiring_responses
end
