require 'rails_helper'

RSpec.describe User, type: :model do
  before(:each) do
    @user = FactoryBot.build(:user)
  end

  it 'has a valid factory' do
    expect(@user).to be_valid
  end

  describe 'Validations' do
    it 'is valid with valid attributes' do
      expect(@user).to be_valid
    end

    it 'is invalid without an email' do
      @user.email = nil
      expect(@user).not_to be_valid
      expect(@user.errors[:email]).to include("can't be blank")
    end

    it 'is invalid with a duplicate email' do
      @user.save
      user2 = FactoryBot.build(:user, email: @user.email)
      expect(user2).not_to be_valid
      expect(user2.errors[:email]).to include('has already been taken')
    end

    it 'is invalid without a password' do
      @user.password = nil
      expect(@user).not_to be_valid
      expect(@user.errors[:password]).to include("can't be blank")
    end

    it 'is invalid if password is too short' do
      @user.password = '123'
      expect(@user).not_to be_valid
      expect(@user.errors[:password]).to include('is too short (minimum is 6 characters)')
    end
  end

  # describe 'Methods' do
  #   it 'responds to a method called custom_method' do
  #     # Assuming you have a custom method in your User model
  #     expect(@user).to respond_to(:custom_method)
  #   end
  # end
end
