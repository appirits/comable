require 'rails/generators'
require 'bundler'
require 'bundler/cli'

module Comable
  class InstallGenerator < Rails::Generators::Base
    class_option :migrate, type: :boolean, default: true, banner: 'Run Comable migrations'
    class_option :seed, type: :boolean, default: true, banner: 'Load seed data (migrations must be run)'
    class_option :sample, type: :boolean, default: true, banner: 'Load sample data (migrations must be run)'
    class_option :admin_email, type: :string
    class_option :admin_password, type: :string

    class << self
      def source_paths
        paths = superclass.source_paths
        paths << File.expand_path('../templates', __FILE__)
        paths.flatten
      end
    end

    def prepare_options
      @migrate_flag = options[:migrate]
      @seed_flag = @migrate_flag ? options[:seed] : false
      @sample_flag = @migrate_flag ? options[:sample] : false
    end

    def add_files
      template 'config/initializers/comable.rb', 'config/initializers/comable.rb'
    end

    def configure_application
      application <<-APP
    config.to_prepare do
      # Overriding Models and Controllers
      # refs: http://edgeguides.rubyonrails.org/engines.html#overriding-models-and-controllers
      Dir.glob(Rails.root.join('app/**/*_decorator*.rb')).each do |c|
        Rails.configuration.cache_classes ? require_dependency(c) : load(c)
      end
    end
      APP
    end

    def append_seeds
      append_file 'db/seeds.rb', <<-SEEDS
# Seed data for Comable
Comable::Core::Engine.load_seed if defined?(Comable::Core)
      SEEDS
    end

    def install_migrations
      say_status :copying, 'migrations'
      quietly { rake 'comable:install:migrations' }
    end

    def create_database
      say_status :creating, 'database'
      quietly { rake 'db:create' }
    end

    def run_migrations
      if @migrate_flag
        say_status :running, 'migrations'
        quietly { rake 'db:migrate' }
      else
        say_status :skipping, "migrations (don't forget to run rake db:migrate)"
      end
    end

    def load_seed_data
      if @seed_flag
        say_status :loading, 'seed data'
        rake_seed
      else
        say_status :skipping, 'seed data (you can always run rake db:seed)'
      end
    end

    def load_sample_data
      if @sample_flag
        say_status :loading, 'sample data'
        quietly { rake 'comable:sample' }
      else
        say_status :skipping, 'sample data (you can always run rake comable:sample)'
      end
    end

    def insert_routes
      insert_into_file File.join('config', 'routes.rb'), after: "Rails.application.routes.draw do\n" do
        <<-ROUTES
  # This line mounts Comable's routes at the root of your application.
  # This means, any requests to URLs such as /products, will go to Comable::ProductsController.
  # If you would like to change where this engine is mounted, simply change the :at option to something different.
  #
  # We ask that you don't use the :as option here, as Comable relies on it being the default of "comable"
  mount Comable::Core::Engine, at: '/'
        ROUTES
      end

      message_for_insert_routes unless options[:quiet]
    end

    def complete
      message_for_complete unless options[:quiet]
    end

    private

    def rake_seed
      rake("db:seed #{rake_seed_arguments.join(' ')}")
    end

    def rake_seed_arguments
      arguments = []
      arguments << "ADMIN_EMAIL=#{options[:admin_email]}" if options[:admin_email]
      arguments << "ADMIN_PASSWORD=#{options[:admin_password]}" if options[:admin_password]
      arguments
    end

    def message_for_insert_routes
      puts '*' * 50
      puts "We added the following line to your application's config/routes.rb file:"
      puts ' '
      puts "    mount Comable::Core::Engine, at: '/'"
    end

    def message_for_complete
      puts '*' * 50
      puts "Comable has been installed successfully. You're all ready to go!"
      puts ' '
      puts 'Enjoy!'
    end
  end
end
