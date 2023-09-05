FactoryBot.define do
  factory :upload do
    name { Faker::Internet.name }
    user
  end
end
