# spec/models/comment_spec.rb
require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:postData) { FactoryBot.create(:post, user: user) }
  let(:comment) { FactoryBot.build(:comment, user: user, post: postData) }

  describe 'associations' do
    it 'belongs to a user' do
      expect(comment).to respond_to(:user)
      expect(comment.user).to eq(user)
    end

    it 'belongs to a post' do
      expect(comment).to respond_to(:post)
      expect(comment.post).to eq(postData)
    end
  end

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(comment).to be_valid
    end

    it 'is not valid without body' do
      comment.body = nil
      expect(comment).not_to be_valid
      expect(comment.errors[:body]).to include("Body can't be blank")
    end
  end

  describe 'creating a comment' do
    it 'is valid with valid attributes' do
      expect(comment).to be_valid
    end

    it 'is not valid without body' do
      comment.body = nil
      expect(comment).not_to be_valid
    end

    it 'is not valid with body longer than 500 characters' do
      comment.body = 'a' * 501
      expect(comment).not_to be_valid
    end
  end
end

