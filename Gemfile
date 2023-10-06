source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.2'
gem 'bootsnap', require: false
gem 'devise'
gem 'doorkeeper'
gem 'httparty'
gem 'jsonapi-resources'
gem 'mpesa_stk'
gem 'pg', '~> 1.1'
gem 'phonelib'
gem 'puma', '~> 5.0'
gem 'rack-attack'
gem 'rack-cors'
gem 'rails', '~> 7.0.7', '>= 7.0.7.2'
gem 'redis'

group :test do
  gem 'webmock'
end

group :development, :test do
  gem 'annotate'
  gem 'debug', platforms: %i[mri mingw x64_mingw]
  gem 'dotenv-rails'
  gem 'faker'
  gem 'rspec-rails'
  gem 'rubocop', require: false
end

group :development do
  gem 'guard'
  gem 'guard-rspec', require: false
end
