source 'https://rubygems.org'

# framework
gem 'rails',                   '4.1.1'

# database
gem 'pg',                      '~> 0.17'
gem 'paranoia',                '~> 2.0'

# external requests
gem 'faraday',                 '~> 0.9'
gem 'faraday_middleware',      '~> 0.9'
gem 'net-http-persistent',     '~> 2.9'
gem 'httparty',                '~> 0.13'

# cli tools
gem 'thor',                    '~> 0.19'
gem 'thor-rails',              '~> 0.0'

# workers & scheduling
gem 'sidekiq',                 '~> 3.2'
gem 'sidetiq',                 '~> 0.6'

# styling
gem 'bootstrap-sass',          '~> 3.2.0'
gem 'sass-rails',              '~> 4.0'
gem 'compass-rails',           '~> 2.0.0'
gem 'uglifier',                '~> 2.5'
gem 'font-awesome-rails',      '~> 4.1.0.0'

# JavaScript
gem 'coffee-rails',            '~> 4.0'
gem 'angular-gem',             '~> 1.2.18.1'    # ETS's library for angular dependency!

# ngmin-rails
# https://github.com/jasonm/ngmin-rails
gem 'ngmin-rails',             '~> 0.4.0'

# Use your angular templates with rails' asset pipeline
# https://github.com/pitr/angular-rails-templates
gem 'angular-rails-templates', '~> 0.1.2'

# formatters
gem 'json',                    '~> 1.8'

# DSLs
gem 'jbuilder',                '~> 2.1'
gem 'haml',                    '~> 4.0'

# LTI support
gem 'ims-lti', :git => 'https://github.com/instructure/ims-lti.git'

group :development do
  gem 'guard-livereload',      '~> 2.2'
  gem 'rack-livereload',       '~> 0.3'

  # Polling is evil:
  # https://github.com/guard/guard#readme
  gem 'rb-fsevent',            '~> 0.9', require: false, :platform => :ruby

  # Adds extra information to the requests
  # Enables the RailsPanel chrome extension
  gem 'meta_request',          '~> 0.3'

  gem 'pry-rails',             '~> 0.3'
end

group :test do
  gem 'page-object',           '~> 1.0'
  gem 'webmock',               '~> 1.18'
end

group :development, :test do
  gem 'rspec',                 '~> 3.0'
  gem 'rspec-rails',           '~> 3.0'
  gem 'guard-rspec',           '~> 4.2'
  gem 'selenium-webdriver',    '~> 2.42'

  gem 'simplecov',             '~> 0.7', require: false

  gem 'capybara',              '~> 2.3'
  gem 'shoulda-matchers',      '~> 2.6', require: false

  # Factories
  gem 'factory_girl',          '~> 4.4'
  gem 'factory_girl_rails',    '~> 4.4'
  gem 'database_cleaner',      '~> 1.3'
  gem 'byebug',                '~> 3.1'
end

group :production  do
  gem 'passenger',              '~> 4.0'
end
