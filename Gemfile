# frozen_string_literal: true

source 'https://rubygems.org'

ruby '3.3.4'

gem 'active_model_serializers', '~> 0.10.14'
gem 'bootsnap', require: false
gem 'jbuilder'
gem 'pg', '~> 1.1'
gem 'puma', '>= 5.0'
gem 'rails', '~> 7.1.3', '>= 7.1.3.4'
gem 'tzinfo-data', platforms: %i[windows jruby]

group :development, :test do
  gem 'debug', platforms: %i[mri windows]
  gem 'factory_bot_rails', '~> 6.4', '>= 6.4.3'
  gem 'pry-byebug'
end

group :test do
  gem 'rspec-mocks', '~> 3.13', '>= 3.13.1'
  gem 'rspec-rails', '~> 6.1', '>= 6.1.4'
  gem 'shoulda-matchers', '~> 6.4'
  gem 'webmock', '~> 3.23', '>= 3.23.1'
end

group :development do
  gem 'rubocop-rails', require: false
end
