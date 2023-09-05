
FactoryBot.define do
  factory :uploads_info do
    name { Faker::Internet.name }
    user
    upload
    protocol { 'http' }
    media_type { rand(1..5) }
    number_of_seeds { rand(0..300) }
    provider { Faker::Company.name }
    duration {  rand(22..1300) }
    description { Faker::Quotes::Chiquito.joke }
  end
end
