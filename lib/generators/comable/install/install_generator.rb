# refs:
#   http://yuma300.hatenablog.com/entry/2013/08/15/221418
#   http://old.thoughtsincomputation.com/posts/cgfr3-part-3-adding-a-generator
#   http://www.dixis.com/?p=444
#   http://stackoverflow.com/questions/10053891/can-i-run-a-rake-task-inside-a-generator

require 'rails/generators/active_record'

module Comable
  module Generators
    class InstallGenerator < ActiveRecord::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      argument :name, default: 'migration'

      def create_product_model
        return if Comable::Engine.config.respond_to?(:product_class)
        template 'product.rb', 'app/models/product.rb'
        migration_template 'create_products.rb', 'db/migrate/create_products.rb'
      end

      def create_customer_model
        return if Comable::Engine.config.respond_to?(:customer_class)
        template 'customer.rb', 'app/models/customer.rb'
        migration_template 'create_customers.rb', 'db/migrate/create_customers.rb'
      end

      def copy_migrations
        rake 'comable:install:migrations'
      end
    end
  end
end
