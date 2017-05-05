class UserDocSerializer < ActiveModel::Serializer
  attributes :id, :name, :doc_type, :user_id, :verified, :doc, :created_at, :updated_at
end
