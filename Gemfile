source 'https://rubygems.org'

# framework
gem 'rails', '4.1.1'

# database
gem 'pg'
gem 'paranoia', '~> 2.0'

# styling
gem 'sass-rails', "~> 4.0"
gem 'uglifier'

# JavaScript
gem 'coffee-rails'
gem 'angular-gem'   # ETS's library for angular dependency!
gem 'jquery-rails'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby

# formatters
gem "json"

# DSLs
gem 'jbuilder'

# external requests
gem 'faraday'


gem 'turbolinks'

# LTI support
gem 'ims-lti', :git => "https://github.com/instructure/ims-lti.git"


# Documentation
gem 'sdoc',          group: :doc

group :development do
  gem "guard-livereload"
  gem "rack-livereload"

  # Polling is evil:
  # https://github.com/guard/guard#readme
  gem "rb-fsevent", "~> 0.9.2", require: false, :platform => :ruby

  # Adds extra information to the requests
  # Enables the RailsPanel chrome extension
  gem "meta_request"
end

group :test do
  gem 'page-object'
  gem "webmock"
end


group :development, :test do
  gem 'rspec'
  gem 'rspec-rails'
  gem 'guard-rspec'
  gem "selenium-webdriver"

  # Code coverage for Ruby 1.9 with a powerful configuration library and automatic merging of coverage across test suites
  # https://rubygems.org/gems/simplecov
  gem "simplecov", "~> 0.7.1", require: false

  # Capybara is an integration testing tool for rack based web applications.
  # It simulates how a user would interact with a website
  # https://rubygems.org/gems/capybara
  gem "capybara"
  gem 'shoulda-matchers', require: false

  # Factories
  gem 'factory_girl'
  gem 'factory_girl_rails'
  gem 'byebug'
end
