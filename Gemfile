source 'https://rubygems.org'
ruby '2.2.0'

gem 'rails', '4.2.0'
gem 'pg' # use for heroku
gem 'app_config'
gem 'rails-i18n', '~> 4.0.0'

# group :(o)auth do
gem 'devise'
gem 'therubyracer'
gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-twitter'
# end

# group :assets do
gem 'sass-rails', '~> 5.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'uglifier', '>= 1.3.0'
# end

# group :features do
gem 'acts_as_votable'
gem 'slim-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 2.0'
gem 'jquery-rails'
gem 'bootstrap-sass', '~> 3.3.3'
gem 'simple_form'
gem 'will_paginate'
gem 'bootstrap-will_paginate'
# gem 'devise-bootstrap-views' # not stable gem
# end

group :development do
  gem "better_errors"
  gem 'guard-bundler'
  gem 'guard-cucumber'
  gem 'guard-rails'
  gem 'guard-rspec'
  gem 'rails_layout'
  gem 'rb-fchange', require: false
  gem 'rb-fsevent', require: false
  gem 'rb-inotify', require: false
  gem 'spring-commands-rspec'
end

group :development, :test do
  gem 'byebug'
  gem 'web-console', '~> 2.0'
  gem 'spring'
  gem 'factory_girl_rails'
  gem 'populator'
  gem 'faker'
  gem 'rspec-rails'
  gem 'cucumber'
  gem 'rubocop'
end

group :test do
  gem 'rspec-its'
  gem 'capybara'
  gem 'database_cleaner'
  gem 'launchy'
  gem 'selenium-webdriver'
end
