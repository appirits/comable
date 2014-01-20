module Comable
  class Engine < ::Rails::Engine
    isolate_namespace Comable

    config.product_default_column_names = %i( name code price caption )
  end
end
