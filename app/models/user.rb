class User < ApplicationRecord

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :access_grants,
           class_name: 'DoorKeeper::AccessGrant',
           foreign_key: :resource_owner_id,
           dependent: :delete_all

  has_many :access_tokens,
           class_name: 'DoorKeeper::AccessToken',
           foreign_key: :resource_owner_id,
           dependent: :delete_all
  has_many :upload_infos, dependent: :destroy
  validates_presence_of :email
  has_many :uploads, dependent: :destroy
  has_one :webhook, dependent: :destroy
end
