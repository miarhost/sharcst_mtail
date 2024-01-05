
FactoryBot.define do
  factory :uploads_info do
    name { Faker::Internet.name }
    user
    upload
    log_tag { Faker::Internet.password }
    media_type { rand(1..5) }
    rating { rand(0..15) }
    provider { Faker::Company.name }
    duration {  rand(22..1300) }
    description { Faker::Quotes::Chiquito.joke }
  end
end
