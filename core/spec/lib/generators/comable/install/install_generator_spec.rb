require 'generators/comable/install/install_generator'

describe Comable::InstallGenerator do
  destination Rails.root.join('tmp')
  arguments %w( --admin_email=admin@example.com --admin_password=password )

  before(:all) do
    quietly { drop_tables }

    prepare_destination

    prepare_directories
    prepare_application
    prepare_routes
    prepare_seeds

    create_link_to_dummy_directory

    run_generator
  end

  after(:all) do
    remove_link_to_dummy_directory
  end

  it 'creates a comable initializer' do
    assert_file 'config/initializers/comable.rb', /Comable\.setup/
  end

  it 'configures application' do
    assert_file 'config/application.rb', /decorator/
  end

  it 'creates seeds' do
    assert_file 'db/seeds.rb', /Comable/
  end

  it 'creates migrations' do
    # TODO: Change the destination directory.
    assert_migration '../db/migrate/create_comable_products.comable.rb' do |migration|
      assert_instance_method :change, migration do |change|
        assert_match(/create_table :comable_products/, change)
      end
    end
  end

  it 'load seeds' do
    expect(Comable::Customer.count).to eq(1)
    expect(Comable::Customer.first.email).to eq('admin@example.com')
    expect(Comable::Customer.first.role).to eq('admin')
  end

  it 'creates routes' do
    assert_file 'config/routes.rb', /mount Comable::Core::Engine/
  end

  private

  def drop_tables
    ActiveRecord::Base.connection.tables.each do |table_name|
      ActiveRecord::Migration.drop_table(table_name)
    end
  end

  def prepare_directories
    FileUtils.mkdir_p("#{destination_root}/config")
    FileUtils.mkdir_p("#{destination_root}/db")
  end

  def prepare_application
    File.open("#{destination_root}/config/application.rb", 'w') do |f|
      f << <<-APP
module Dummy
  class Application < Rails::Application
  end
end
      APP
    end
  end

  def prepare_routes
    File.open("#{destination_root}/config/routes.rb", 'w') do |f|
      f << <<-ROUTES
Rails.application.routes.draw do
end
      ROUTES
    end
  end

  def prepare_seeds
    FileUtils.touch("#{destination_root}/db/seeds.rb")
  end

  # Need for migration and loading seed
  def create_link_to_dummy_directory
    FileUtils.ln_sf("#{destination_root}/db", Rails.root.join('db'))
  end

  def remove_link_to_dummy_directory
    FileUtils.rm(Rails.root.join('db'))
  end
end
