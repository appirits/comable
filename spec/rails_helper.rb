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

# for Feature test
require 'capybara'
require 'phantomjs'
require 'phantomjs/poltergeist'
require 'database_cleaner'

# Change Capybara javascript driver to Poltergeist (PhantomJS)
Capybara.javascript_driver = :poltergeist

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

# for FactoryGirl
require 'factory_girl'
Dir[Rails.root.join('spec/factories/**/*.rb')].each { |f| require f }

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # Modules
  config.include Comable::EngineControllerTestMonkeyPatch, type: :controller
  config.include Devise::TestHelpers, type: :view
  config.include Devise::TestHelpers, type: :controller
  config.extend Comable::AuthorizationHelpers::Controller, type: :controller
  config.extend Comable::AuthorizationHelpers::Feature, type: :feature
  config.extend Comable::RequestHelpers, type: :request

  # for Rspec 3
  # refs: https://github.com/rspec/rspec-rails/issues/932#issuecomment-43521700
  config.infer_spec_type_from_file_location!

  # Omit the prefix FactoryGirl
  config.include FactoryGirl::Syntax::Methods

  # Support Capybara DSL for the feature test
  config.include Capybara::DSL, type: :feature

  #
  # DatabaeeCleaner for the asynchronous test (with :js option).
  #
  config.use_transactional_fixtures = false

  # Clean up database before test
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  # Start the transaction
  config.before(:each) do |example|
    DatabaseCleaner.strategy = example.metadata[:js] ? :truncation : :transaction
    DatabaseCleaner.start
  end

  # Clean up database by the strategy
  config.after(:each) do
    DatabaseCleaner.clean
  end
end
