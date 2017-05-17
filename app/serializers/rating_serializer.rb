class RatingSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :user, :hospital, :created_by_id, :staffing_response_id, :stars, :comments

  belongs_to :user, serializer: UserMiniSerializer
end