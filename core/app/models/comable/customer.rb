module Comable
  class Customer < ActiveRecord::Base
    include CartOwner

    has_many :orders, class_name: Comable::Order.name, foreign_key: table_name.singularize.foreign_key
    has_many :addresses, class_name: Comable::Address.name, foreign_key: table_name.singularize.foreign_key
    belongs_to :bill_address, class_name: Comable::Address.name
    belongs_to :ship_address, class_name: Comable::Address.name

    accepts_nested_attributes_for :addresses
    accepts_nested_attributes_for :bill_address
    accepts_nested_attributes_for :ship_address

    devise(*Comable::Config.devise_strategies[:customer])

    def initialize(*args)
      obj = args.first
      case obj.class.name
      when /Cookies/
        Rails.logger.debug '[DEPRECATED] Comable::Customer#new(cookies) is deprecated. Please use Comable::Customer#with_cookies(cookies) method.'
        @cookies = obj
        super()
      else
        super
      end
    end

    def with_cookies(cookies)
      @cookies = cookies
      self
    end

    # Add conditions for the orders association.
    # Override method of the orders association to support Rails 3.x.
    def orders
      super.complete
    end

    def other_addresses
      addresses - [bill_address] - [ship_address]
    end

    def signed_in?
      !new_record?
    end

    def not_signed_in?
      !signed_in?
    end

    def reset_cart
      return unless incomplete_order

      # TODO: テストケースの作成
      incomplete_order.destroy if incomplete_order.incomplete?

      @incomplete_order = nil
    end

    def cart_items
      incomplete_order.order_deliveries.first.order_details
    end

    def incomplete_order
      @incomplete_order ||= initialize_incomplete_order
    end

    def preorder(order_params = {})
      incomplete_order.attributes = order_params
      incomplete_order.precomplete!
      incomplete_order
    end

    def order(order_params = {})
      incomplete_order.attributes = order_params
      incomplete_order.complete!
      incomplete_order.tap { |completed_flag| reset_cart if completed_flag }
    end

    private

    def current_guest_token
      @cookies.signed[:guest_token] if @cookies
    end

    def initialize_incomplete_order
      orders = find_incomplete_orders
      return orders.first if orders.any?
      order = orders.create(incomplete_order_attributes)
      @cookies.permanent.signed[:guest_token] = order.guest_token if @cookies
      order
    end

    def incomplete_order_attributes
      {
        self.class.table_name.singularize.foreign_key => id,
        guest_token: current_guest_token,
        email: email,
        # TODO: Remove
        family_name: family_name,
        first_name: first_name,
        order_deliveries_attributes: [{ family_name: family_name, first_name: first_name }]
      }
    end

    def find_incomplete_orders
      Comable::Order
        .incomplete
        .includes(order_deliveries: :order_details)
        .where(guest_token: current_guest_token)
        .by_customer([self, nil])
        .limit(1)
    end
  end
end
