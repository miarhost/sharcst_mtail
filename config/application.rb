require_relative 'boot'

require 'rails'
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'active_storage/engine'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_mailbox/engine'
require 'action_text/engine'
require 'action_view/railtie'
require 'action_cable/engine'

Bundler.require(*Rails.groups)

module SharcstMtail
  class Application < Rails::Application
    config.load_defaults 6.0
    config.autoload_paths += Dir[Rails.root.join('lib', '{**}')]
    config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect'
    config.active_job.queue_adapter = :sidekiq
    config.application_host = ENV.fetch('APPLICATION_HOST', '')
    config.api_only = true
  end
end
