FactoryBot.define do
  factory :post do
    body { Faker::Lorem.sentence(word_count: 33) }
    association :user
  end
end
