# config valid for current version and patch releases of Capistrano
lock '~> 3.17.3'

set :application, 'sharcst_mtail'
set :repo_url, 'git@github.com:miarhost/sharcst_mtail.git'
set :use_sudo, true
set :branch, 'main'

# config valid for current version and patch releases of Capistranolock "~> 3.16.0"set :application, "demo_app"set :repo_url, 'https://github.com/shreya-bacancy/demo_app.git'set :deploy_to, '/home/ubuntu/demo_app'set :use_sudo, trueset :branch, 'master'set :linked_files, %w{config/master.key config/database.yml}set :rails_env, 'production'set :keep_releases, 2set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')
set :linked_files, %w{config/database.yml config/master.key}# Default branch is :master
# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/var/www/sharcst/#{fetch(:application)}"

set :all_roles, %i[web worker db]

set :decompose_restart, [:web]

set :decompose_web_service, :web

set :decompose_rake_tasks, ['db:migrate', 'one_time_tasks:additional_infos_creation']

on roles(:web) do
  execute "docker-compose -f docker-compose.yml up"
end

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# Default value for linked_dirs is []
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'tmp/webpacker', 'public/system', 'vendor', 'storage'

# Default value for default_env is {}

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
set :keep_releases, 15

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure

# sidekiq
set :sidekiq_roles, %i[worker]
set :sidekiq_config, -> { Rails.root.join('config', 'sidekiq.yml') }
set :sidekiq_default_hooks, true

# config valid for current version and patch releases of Capistranolock "~> 3.16.0"set :application, "demo_app"set :repo_url, 'https://github.com/shreya-bacancy/demo_app.git'set :deploy_to, '/home/ubuntu/demo_app'set :use_sudo, trueset :branch, 'master'set :linked_files, %w{config/master.key config/database.yml}set :rails_env, 'production'set :keep_releases, 2set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')
set :linked_files, %w{config/database.yml config/master.key}# Default branch is :master
