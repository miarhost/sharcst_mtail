FactoryBot.define do
  factory :subscription do
    title { Faker::Books::Dune }
    topic
  end
end
