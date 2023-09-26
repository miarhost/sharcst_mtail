require 'capistrano/setup'
require 'capistrano/deploy'
require 'capistrano/linked_files'
require 'capistrano/scm/git'
require 'capistrano/nginx'
require 'capistrano/sidekiq'
require 'capistrano/decompose'

install_plugin Capistrano::Sidekiq
install_plugin Capistrano::Sidekiq::Systemd

install_plugin Capistrano::SCM::Git

# Load custom tasks from `lib/capistrano/tasks` if you have any defined
Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }
