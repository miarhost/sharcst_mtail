FactoryBot.define do
  factory :upload do
    name { Faker::Internet.name }
    user
    ahoy_visit_id { 1}
  end
end
