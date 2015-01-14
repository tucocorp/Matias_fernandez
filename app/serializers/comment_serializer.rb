class CommentSerializer < ActiveModel::Serializer
  attributes :id, :content, :created_at, :commentable_id, :commentable_type

  has_one :user
end
