set :stage, :production

set :rails_env, :production

server ENV['HOST'], user: 'ec2-user', roles: %w{web worker db}

set :ssh_options, {
  forward_agent: true,
  auth_methods: %w[publickey],
  keys: [ENV['SSH_PATH']]
  }
