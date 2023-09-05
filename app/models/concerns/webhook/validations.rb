module Webhook::Validations
  extend ActiveSupport::Concern
  URL_REGEX = URI::DEFAULT_PARSER.make_regexp(%w[http https])
  DENIED_HOSTS = %w[localhost 127.0.0.1].freeze
  included do
    validates :url, presence: true, format: { with: URL_REGEX }

    validate :url_plug

    def url_plug
      return if url.blank?

      uri = URI(url)
      errors.add(:url, 'is invalid') if DENIED_HOSTS.include?(uri.host)
    end
  end
end
