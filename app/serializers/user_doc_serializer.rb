class UserDocSerializer < ActiveModel::Serializer
  attributes :id, :name, :doc_type, :user_id, :verified, :doc, :notes, :created_at, :updated_at
end
