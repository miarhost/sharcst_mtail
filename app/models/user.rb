class User < ApplicationRecord

  has_many :access_grants,
           class_name: 'DoorKeeper::AccessGrant',
           foreign_key: :resource_owner_id,
           dependent: :delete_all

  has_many :access_tokens,
           class_name: 'DoorKeeper::AccessToken',
           foreign_key: :resource_owner_id,
           dependent: :delete_all

  has_many :uploads_infos, dependent: :destroy
  validates_presence_of :email
  has_many :uploads, dependent: :destroy
  has_one :webhook, dependent: :destroy
  belongs_to :team, optional: true
  has_secure_password
  has_recommended :uploads
  has_many :locations, as: :locatable

  scope :admins, -> { select{ |u| u.roles.include?('admin')} }

  scope :similar_subscriptions, ->(arr) do
    where('subscription_ids IS NOT NULL AND subscription_ids @> ARRAY[?]::integer[]', arr)
  end

  scope :have_subscription, ->(id) do
    query = <<-SQL
      select * from users
      where #{id} = any(users.subscription_ids);
    SQL
    find_by_sql(query)
  end

  def admin_list_cached
    Rails.cache.fetch([cache_key, __method__], expires_in: 1.hour) do
      uploads.includes(:upload_attachment, :webhooks)
                  .references(:upload_attachment, :webhooks)
                  .order(name: :asc)
    end
  end
end
