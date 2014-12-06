module Comable
  module ApplicationHelper
    def current_store
      @current_store ||= Comable::Store.instance
    end

    # Override the devise method.
    # The below codes move to core/lib/comable/core/engine.rb:
    #
    # def current_customer
    #   ...
    # end

    def current_order
      current_customer.incomplete_order
    end

    def next_order_path
      return comable.next_order_path(state: :orderer) if current_order.state?(:cart)
      comable.next_order_path(state: current_order.state)
    end

    def name_with_honorific(name)
      I18n.t('comable.honorific', name: name)
    end

    def name_with_quantity(name, quantity)
      return name unless quantity
      return name if quantity <= 1
      [
        name,
        "x#{quantity}"
      ].join(' ')
    end
  end
end
