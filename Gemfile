source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.1'
# Use postgresql as the database for Active Record
gem 'pg'

gem 'sass-rails', "~> 4.0"
gem 'uglifier'
gem 'coffee-rails'


# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby

# A JSON implementation as a Ruby extension in C
# http://flori.github.com/json/
gem "json"

# Make external requests
gem 'faraday'

# LTI support
gem 'ims-lti', :git => "https://github.com/instructure/ims-lti.git"

# ETS's library for angular dependency!
gem "angular-gem"

gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc',          group: :doc

group :development do
  # Automatically reloads your browser when "view" files are modified.
  # https://github.com/guard/guard-livereload
  gem "guard-livereload"
  gem "rack-livereload"
  #gem "spring"

  # Polling is evil:
  # https://github.com/guard/guard#readme
  gem "rb-inotify", "~> 0.9.0", require: false, :platform => :ruby
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
  # We need to specify the latest webdriver here, to support the latest firefox
  gem "selenium-webdriver"

  # Code coverage for Ruby 1.9 with a powerful configuration library and automatic merging of coverage across test suites
  # https://rubygems.org/gems/simplecov
  gem "simplecov", "~> 0.7.1", require: false

  # Capybara is an integration testing tool for rack based web applications.
  # It simulates how a user would interact with a website
  # https://rubygems.org/gems/capybara
  gem "capybara"

  # Factories
  gem 'factory_girl'
  gem 'factory_girl_rails'

  gem 'byebug'
end
