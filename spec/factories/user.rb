FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    roles { ['admin', 'user'] }
    phone_number { ENV['TWILIO_TEST_USER_NUMBER'] }
  end
end
