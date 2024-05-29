source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.1'

gem 'active_model_serializers'
gem 'activestorage-validator'
gem "ahoy_matey"
gem "aws-sdk-s3", require: false
gem 'bcrypt', '~> 3.1.7'
gem 'bootsnap', '>= 1.4.2', require: false
gem 'bunny'
gem 'cloudinary'
gem 'disco'
gem 'doorkeeper'
gem 'doorkeeper-jwt'
gem 'dotenv-rails'
gem 'faraday'
gem 'geocoder'
gem 'geoip'
gem 'image_processing', '~> 1.2'
gem 'jwt'
gem 'kaminari'
gem 'newrelic_rpm'
gem 'opensearch-ruby'
gem 'pg', '~> 1.5.6'
gem 'puma', '~> 4.1'
gem 'pundit'
gem 'rack-cors'
gem 'rails', '~> 7.0.0'
gem 'redis', '~> 4.0'
gem 'redis-namespace'
gem 'redis-rails'
gem 'redis-store'
gem 'rest-client'
gem 'sidekiq'
gem 'sidekiq-status'
gem 'swagger-blocks'
gem 'tf-idf-similarity'
gem 'twilio-ruby'
gem 'whenever', require: false

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'faker'
  gem 'factory_bot_rails'
  gem 'rspec-rails', '~> 3.0'
  gem 'webmock'
end

group :test do
  gem 'shoulda-matchers'
  gem 'rspec-json_expectations'
end

group :development do
  gem 'capistrano', '~> 3.17', require: false
  gem 'capistrano-rails'
  gem 'capistrano-sidekiq'
  gem 'capistrano-puma'
  gem 'capistrano-nginx'
  gem 'capistrano-linked-files'
  gem 'listen', '~> 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
gem 'mimemagic', github: 'mimemagicrb/mimemagic', ref: '01f92d86d15d85cfd0f20dabd025dcbd36a8a60f'
