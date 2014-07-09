require 'slim'

module Comable
  class Engine < ::Rails::Engine
    isolate_namespace Comable

    # Bulletと競合するため、Bulletよりあとに有効になるよう初期化順序を調整
    initializer :comable_columns_mapper do
      enable_bullet
      Comable::ColumnsMapper.enable
    end

    private

    def enable_bullet
      return unless Object.const_defined? :Bullet
      Bullet.enable = true
    end
  end
end
