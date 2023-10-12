FactoryBot.define do
  factory :newsletter do
    subscription
    uploads_info_id { 1 }
    header { 'New Event' }
    name { Faker::Creature::Cat }
  end
end
