class HiringResponseSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :hiring_request_id, :notes
  belongs_to :user
end
