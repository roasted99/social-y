FactoryBot.define do
  factory :user do
    username {Faker::Internet.username}
    email { Faker::Internet.email }
    password { 'password123' }
    password_confirmation { 'password123' }
  end
end
