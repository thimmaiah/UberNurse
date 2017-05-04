class UserDocSerializer < ActiveModel::Serializer
  attributes :id, :name, :doc_type, :user_id
end
