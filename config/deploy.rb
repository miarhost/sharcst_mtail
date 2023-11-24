# config valid for current version and patch releases of Capistrano
lock '~> 3.17.3'

set :application, 'sharcst_mtail'
set :repo_url, 'git@github.com:miarhost/sharcst_mtail.git'
set :use_sudo, true
set :branch, 'main'
set :user, 'ec2-user'

# config valid for current version and patch releases of Capistranolock "~> 3.16.0"set :application, "demo_app"set :repo_url, 'https://github.com/shreya-bacancy/demo_app.git'set :deploy_to, '/home/ubuntu/demo_app'set :use_sudo, trueset :branch, 'master'set :linked_files, %w{config/master.key config/database.yml}set :rails_env, 'production'set :keep_releases, 2set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')
set :linked_files, %w{config/database.yml config/master.key .env docker-compose.yml Dockerfile Gemfile Gemfile.lock docker/nginx/nginx.conf docker/html/index.html}

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name

set :all_roles, %i[web worker db]

namespace :deploy do
  task :cleanup_orphaned_containers do
    on roles(:web) do
      within release_path do
        execute("cd #{release_path} && docker system prune -a -f --volumes")
      end
    end
  end

  task :create_nginx_network do
    on roles(:web) do
      within release_path do
        execute("cd #{release_path} && docker network ls|grep nginx_network > /dev/null || docker network create nginx_network")
      end
    end
  end

  task :run_composer do
    on roles(:web) do
      within release_path do
        execute("cd #{release_path} && docker-compose -f /var/www/sharcst/sharcst_mtail/shared/docker-compose.yml down")
        execute("cd #{release_path} && docker-compose -f /var/www/sharcst/sharcst_mtail/shared/docker-compose.yml up -d")
      end
    end
  end
end

set :upload_roles, %i[web worker db]

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# Default value for linked_dirs is []
append :linked_dirs, 'tmp/pids', 'tmp/sockets', 'public'

# Default value for default_env is {}

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
set :keep_releases, 2

set :connection_timeout, 5
before "deploy:starting", "deploy:cleanup"

before 'deploy:check', 'linked_files:upload'
# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure
after 'deploy:updated', 'deploy:create_nginx_network'
after 'deploy:create_nginx_network', 'deploy:cleanup_orphaned_containers'
after 'deploy:cleanup_orphaned_containers', 'deploy:run_composer'

# sidekiq
#set :sidekiq_roles, %i[worker]
#set :sidekiq_config, -> { Rails.root.join('config', 'sidekiq.yml') }
#set :sidekiq_default_hooks, true
