require 'slim'

module Comable
  class Engine < ::Rails::Engine
    isolate_namespace Comable

    # Bulletと競合するため、Bulletよりあとに有効になるよう初期化順序を調整
    initializer :comable_columns_mapper do
      config.after_initialize { Comable::ColumnsMapper.enable }
    end
  end
end
