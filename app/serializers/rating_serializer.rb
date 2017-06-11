class RatingSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :user, :care_home, :created_by_id, :shift_id, :stars, :comments

  belongs_to :user, serializer: UserMiniSerializer
end
