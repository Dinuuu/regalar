source 'http://rubygems.org'

ruby "2.0.0"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.4'

gem 'google-webfonts-rails'

# Use postgresql as the database for Active Record
gem 'pg'

# Use postgresql as the full text search engine.
gem 'pg_search'

# To extract sensitive configuration
gem 'app_configuration'

# Use unicorn as the app server
gem 'unicorn'

# Use AASM as a state machine engine
gem 'aasm'

group :assets do
  # Use SCSS for stylesheets
  gem 'sass-rails',   '~> 4.0.0'

  # Use CoffeeScript for .js.coffee assets and views
  gem 'coffee-rails', '~> 4.0.0'

  # Use Uglifier as compressor for JavaScript assets
  gem 'uglifier', '>= 1.0.3'
end

gem 'less-rails'
gem 'therubyracer'
gem 'twitter-bootstrap-rails', git: 'git://github.com/seyhunak/twitter-bootstrap-rails.git',
                               branch: 'bootstrap3'

# Use jquery as the JavaScript library
gem 'jquery-rails'

gem 'loadjs'

gem 'inherited_resources'

# Uploader images
gem 'carrierwave'

gem 'fog'

# Upload videos
gem 'carrierwave-video'
gem 'postgresql_lo_streamer'

gem 'jquery-turbolinks'

gem 'devise'

#CodeClimate Reporter
gem "codeclimate-test-reporter", group: :test, require: nil
gem 'simplecov', require: false, group: :test

# Active Admin
gem 'activeadmin', github: 'gregbell/active_admin'
gem 'formtastic', github: 'justinfrench/formtastic'

# Enables Slim templates
gem "slim-rails"

# Resque, Resque Mailer and Scheduler
# gem 'resque'
# gem 'resque_mailer'
# gem "resque-batched-job"
# gem 'rufus-scheduler'
# gem 'resque-scheduler', require: 'resque_scheduler'

# Authorization System
gem 'pundit'

# Oauth Login
gem 'omniauth-facebook'
gem 'omniauth-google-oauth2'
gem 'omniauth-twitter'

# Validates dates
gem 'validates_timeliness', '~> 3.0'

# Nested Form with Jquery
gem 'cocoon'

# Mails preview
gem 'mail_view', git: 'https://github.com/basecamp/mail_view.git'

# Send mails when errors occur
gem 'exception_notification'

# Rich text input
gem 'tinymce-rails'
gem 'tinymce-rails-langs'


# Validate forms
gem 'jquery-validation-rails'

# Pagination
gem 'kaminari'

# Share Links
gem 'shareable'

# Image upload
gem "nested_form"

gem 'addressable'


group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'rubocop'
  gem 'railroady'
end

#group :debugging, :development, :test do
#  gem 'pry'
#  gem 'debugger'
#  gem 'debugger-pry'
#  gem 'pry-nav'
#  gem 'pry-stack_explorer'
#end

group :test, :development do

  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'cucumber-rails', require: false
  gem 'database_cleaner', github: 'bmabey/database_cleaner'

  # Modify time in tests
  gem 'timecop'

  # Cucumber with JS
  gem 'poltergeist'

  # Save and open page cucumber
  gem 'launchy'

  gem 'byebug'
end

group :production, :staging do
  gem 'rails_12factor'
end
