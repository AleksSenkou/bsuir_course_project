ENV['RAILS_ENV'] ||= 'test'
require 'spec_helper'
require File.expand_path('../../config/environment', __FILE__)
require 'capybara/rspec'
require 'capybara/rails'
require "devise"
require 'rspec/rails'

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.mock_with :rspec do |c|
    c.syntax = [:should, :expect]
  end
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  # config.extend ControllerMacros, type: :controller
  config.use_transactional_fixtures = false
  config.render_views
  config.infer_spec_type_from_file_location!
  config.include Capybara::DSL
  config.extend ControllerMacros, type: :controller
  config.include Devise::TestHelpers, type: :controller
end
