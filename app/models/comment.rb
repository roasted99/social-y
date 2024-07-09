class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post

  validates :body, presence: { message: "Body can't be blank" }, allow_blank: false, length: { maximum: 420, minimum: 1 }
end
