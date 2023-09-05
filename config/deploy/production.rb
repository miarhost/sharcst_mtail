set :stage, :production

server '127.0.0.1', roles: ['web'], user: fetch(:user)

server '127.0.0.18', roles: ['worker'], user: fetch(:user)

server '127.0.0.36', roles: ['db'], user: fetch(:user)
