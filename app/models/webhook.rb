require 'securerandom'
class Webhook < ApplicationRecord
  include Webhook::Validations

  has_many :webhook_responses
  belongs_to :user

  enum state: { disabled: 0, enabled: 1, disabled_by_admin: 2, deleted: 3 }
end
