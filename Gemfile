source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gem 'active_model_serializers'
gem 'ahoy_matey'
gem 'awesome_print'
gem 'carrierwave'
gem 'carrierwave-i18n'
gem 'colorize'
gem 'devise'
gem 'dotenv-rails'
gem 'exception_notification'
gem 'faraday'
gem 'faraday_middleware'
gem 'httparty'
gem 'interactor'
gem 'lograge'
gem 'mongoid'
gem 'oj'
gem 'oj_mimic_json'
gem 'pundit'
gem 'reform'
gem 'reform-rails'
gem 'rubocop', require: false
gem 'sidekiq'
gem 'sidekiq-scheduler'
gem 'sneakers'
gem 'thinking-sphinx'
gem 'unicorn'
gem 'virtus'
gem 'wicked_pdf'
gem 'with_advisory_lock'
gem 'wkhtmltopdf-binary'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.2'
# Use mysql as the database for Active Record
gem 'mysql2', '>= 0.4.4', '< 0.6.0'
# Use Puma as the app server
gem 'puma', '~> 3.11'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors'

group :development, :test do
  gem 'action-cable-testing'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'fuubar'
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  gem 'bullet'
  gem 'capistrano', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-rbenv', require: false
  gem 'capistrano-sidekiq', require: false
  gem 'capistrano-sneakers', require: false
  gem 'capistrano3-unicorn', require: false
end

group :test do
  gem 'database_cleaner'
  gem 'json_spec'
  gem 'rails-controller-testing'
  gem 'rspec-its'
  gem 'rspec-rails', '~> 3.8'
  gem 'rspec-sidekiq'
  gem 'shoulda-matchers'
  gem 'simplecov', require: false
  gem 'webmock'
end


# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
