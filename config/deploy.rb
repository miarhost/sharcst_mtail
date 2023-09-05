# config valid for current version and patch releases of Capistrano
lock '~> 3.17.3'

set :application, 'sharcst_mtail'
set :repo_url, 'git@example.com:me/my_repo.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/home/#{fetch(:user)}/application/#{sharcst_mtail}"

set :all_roles, %i[web worker db]

# rvm
set :rvm_type, :user
set :rvm_ruby_version, '2.7.1'

before 'deploy:assets:precompile', 'deploy:yarn_install'
before 'deploy:starting', 'assets:precompile'
after 'deploy:assets:precompile', 'assets:upload'

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
append :linked_files, 'config/database.yml', 'config/master.key'

# Default value for linked_dirs is []
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'tmp/webpacker', 'public/system', 'vendor', 'storage'

# Default value for default_env is {}
set :default_env, { path: '/opt/ruby/bin:$PATH' }

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

namespace :deploy do
  task :yarn_install do
    run_locally do
      execute('yarn inslall --silent --no-optional')
    end
  end
end
