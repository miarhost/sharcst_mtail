FactoryBot.define do
  factory :webhook do
    url { Faker::Internet.url }
    state { 'disabled' }
    secret { SecureRandom.urlsafe_base64(3) }
    user
  end
end
