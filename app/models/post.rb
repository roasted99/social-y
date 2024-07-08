class Post < ApplicationRecord
  belongs_to :user
  validates :body, allow_blank: false, length: { maximum: 420 }
end
