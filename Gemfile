source 'https://rubygems.org'

# framework
gem 'rails',                   '4.1.8'

# database
gem 'pg',                      '~> 0.17'
gem 'paranoia',                '~> 2.0.4'

# external requests
gem 'faraday',                 '~> 0.9'
gem 'faraday_middleware',      '~> 0.9'
gem 'net-http-persistent',     '~> 2.9'

# process management
gem 'foreman',                 '~> 0.76.0'

# cli tools
gem 'thor',                    '~> 0.19'
gem 'thor-rails',              '~> 0.0'

# workers & scheduling
gem 'sidekiq',                 '~> 3.3.0'
gem 'clockwork',               '~> 1.0.0'
gem 'clockworkd',              '~> 0.2.5'
gem 'daemons',                 '~> 1.1.9'

# styling
gem 'bootstrap-sass',          '~> 3.3.1.0'
gem 'sass-rails',              '~> 4.0.4'
gem 'compass-rails',           '~> 2.0.0'
gem 'uglifier',                '~> 2.5'
gem 'font-awesome-rails',      '~> 4.2.0.0'

# JavaScript
gem 'coffee-rails',            '~> 4.0'
gem 'angular-gem',             '~> 1.3.6'

# https://rubygems.org/gems/ngannotate-rails
gem 'ngannotate-rails',        '~> 0.14.1'

# Use your angular templates with rails' asset pipeline
# https://github.com/pitr/angular-rails-templates
gem 'angular-rails-templates', '~> 0.1.3'

# formatters / decorators
gem 'json',                    '~> 1.8'
gem 'decorated_csv',           '~> 1.0.0'

# DSLs
gem 'jbuilder',                '~> 2.1'
gem 'haml',                    '~> 4.0'

# LTI support
gem 'ims-lti', :git => 'https://github.com/instructure/ims-lti.git'

group :test do
  gem 'page-object',           '~> 1.0'
  gem 'webmock',               '~> 1.18'
end

group :development, :test do
  gem 'rspec',                 '~> 3.0'
  gem 'rspec-rails',           '~> 3.0'
  gem 'guard-rspec',           '~> 4.2'
  gem 'selenium-webdriver',    '~> 2.44'

  # Debugging
  gem 'byebug',                '~> 3.1'
  gem 'pry-rails',             '~> 0.3'

  gem 'simplecov',             '~> 0.7', require: false

  gem 'capybara',              '~> 2.3'
  gem 'shoulda-matchers',      '~> 2.6', require: false

  # Factories & DataBase manipulation
  gem 'factory_girl',          '~> 4.4'
  gem 'factory_girl_rails',    '~> 4.4'
  gem 'faker',                 '~> 1.4.3'
  gem 'database_cleaner',      '~> 1.3'
end

group :production  do
  gem 'passenger',              '~> 4.0'
end
