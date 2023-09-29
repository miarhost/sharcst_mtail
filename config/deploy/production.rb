set :stage, :production

set :rails_env, :production

set :deploy_to, "/var/www/sharcst/#{fetch(:application)}"

server '16.16.25.76', user: 'ec2-user', roles: %w{web worker db}

set :ssh_options, {
  forward_agent: true,
  verify_host_key: :always
  }
