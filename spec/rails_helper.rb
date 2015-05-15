# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'

require 'coveralls'
Coveralls.wear!('rails')

require File.expand_path('../spec_helper', __FILE__)
require File.expand_path('../dummy/config/environment', __FILE__)
require 'rspec/rails'
require 'rspec/its'
require 'rspec/example_steps'
require 'shoulda/matchers'
require 'generator_spec'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

# for FactoryGirl
require 'factory_girl'
Dir[Rails.root.join('spec/factories/**/*.rb')].each { |f| require f }

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  config.include Comable::EngineControllerTestMonkeyPatch, type: :controller
  config.include Devise::TestHelpers, type: :view
  config.include Devise::TestHelpers, type: :controller
  config.extend Comable::AuthHelpers, type: :controller
  config.extend Comable::RequestHelpers, type: :request

  # for Rspec 3
  # refs: https://github.com/rspec/rspec-rails/issues/932#issuecomment-43521700
  config.infer_spec_type_from_file_location!

  # Omit the prefix FactoryGirl
  config.include FactoryGirl::Syntax::Methods
end
