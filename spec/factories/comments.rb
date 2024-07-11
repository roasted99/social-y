FactoryBot.define do
  factory :comment do
    association :user
    association :post
    body { Faker::Lorem.sentence(word_count: 24) }
  end
end
