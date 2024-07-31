FactoryBot.define do
  factory :recommendations_stat do
    association :statable, factory: :category_stat
    uploads_recs { "[{\"user\":1,\"upload\":2},{\"user\":1,\"upload\":3}]" }
    infos_ratings { "[{\"upload\":1,\"uploads_info\":4,\"score\":0.690576255321503}]" }
    user_ids { [1,2] }
  end
end
