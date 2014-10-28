module Comable
  module ApplicationHelper
    def current_store
      @current_store || load_store
    end

    def current_customer
      @current_customer || load_customer
    end

    def current_order
      current_customer.incomplete_order
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

    private

    def load_store
      @current_store = Comable::Store.instance
    end

    def load_customer
      @current_customer = warden.authenticate(scope: :customer) if warden
      @current_customer ||= Comable::Customer.new(cookies)
    end
  end
end
