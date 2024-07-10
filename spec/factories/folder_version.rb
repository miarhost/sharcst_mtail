FactoryBot.define do
  factory :folder_version do
    user
    upload
    version { "1" }
  end
end
