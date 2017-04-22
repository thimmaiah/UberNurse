class HiringResponseSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :hiring_request_id, :notes, :user
  belongs_to :user, serializer: UserMiniSerializer
end
