class Post < ApplicationRecord
  belongs_to :user
  has_many :comments

  validates :body, presence: { message: "Body can't be blank" }, allow_blank: false, length: { maximum: 420, minimum: 1 }
end
