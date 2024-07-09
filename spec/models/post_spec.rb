require 'rails_helper'

RSpec.describe Post, type: :model do
  before(:each) do
    @post = FactoryBot.build(:post)
  end

  it 'has a valid factory' do
    expect(@post).to be_valid
  end

  describe 'Validations' do
    it 'is valid with valid attributes' do
      expect(@post).to be_valid
    end


    it 'is invalid without body' do
      @post.body = nil
      expect(@post).not_to be_valid
      expect(@post.errors[:body]).to include("Body can't be blank")
    end

    it 'is invalid without a user' do
      @post.user = nil
      expect(@post).not_to be_valid
      expect(@post.errors[:user]).to include("must exist")
    end
  end

  # describe 'Methods' do
  #   it 'responds to a method called custom_method' do
  #     # Assuming you have a custom method in your Post model
  #     expect(@post).to respond_to(:custom_method)
  #   end
  # end
end
