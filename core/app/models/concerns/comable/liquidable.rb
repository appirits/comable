module Comable
  module Liquidable
    extend ActiveSupport::Concern

    module ClassMethods
      # from: http://www.codedisqus.com/0SHjkUjjgW/how-can-i-expose-all-available-liquid-methods-for-a-model.html
      def available_liquid_methods
        self::LiquidDropClass.public_instance_methods - Liquid::Drop.public_instance_methods
      end
    end
  end
end
