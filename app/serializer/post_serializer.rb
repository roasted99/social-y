# app/serializers/post_serializer.rb
class PostSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_at, :updated_at

  belongs_to :user, serializer: UserSerializer
  has_many :comments, serializer: CommentSerializer
end

# app/serializers/user_serializer.rb


# app/serializers/comment_serializer.rb

