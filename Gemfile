source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.2'
# Use Puma as the app server
gem 'puma', '~> 3.0'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
group :development do
    gem 'capistrano',         require: false
    gem 'capistrano-rvm',     require: false
    gem 'capistrano-rails',   require: false
    gem 'capistrano-bundler', require: false
    gem 'capistrano3-puma',   require: false
end

gem 'mysql2'
gem 'jdbc-mysql',      '= 5.1.35', :platform => :jruby
gem 'thinking-sphinx', '~> 3.3.0'

gem 'oauth'
gem 'active_model_serializers'
gem 'rack-cors', :require => 'rack/cors'
gem 'cancancan'

gem 'rack-attack'
gem 'omniauth'
gem 'devise_token_auth'
# for background tasks
gem 'delayed_job'
gem 'delayed_job_active_record'
gem 'daemons'

gem "paperclip", "~> 5.0.0"
gem 'aws-sdk'
gem 'faker'


group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
  gem 'rspec-rails', '~> 3.5'
end

group :development do
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'letter_opener_web'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem 'factory_girl_rails'
gem 'exception_notification'
gem 'dotenv-rails'
gem 'rest-client'
gem "administrate"
gem "paranoia", "~> 2.2"
gem "geocoder"
gem 'paper_trail'
gem 'sanitize_email'
gem 'responders'
gem 'whenever', :require => false
gem 'capybara-email'
# gem 'high_voltage'
gem 'roadie'

group :test do
  gem 'cucumber-rails', require: false
  gem 'database_cleaner'
  gem 'factory_girl_rails'
  gem 'selenium-webdriver'
  gem "chromedriver-helper"
  gem 'formulaic'
end
