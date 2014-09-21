module Comable
  class Customer < ActiveRecord::Base
    include CartOwner

    has_many :comable_orders, class_name: Comable::Order.name, foreign_key: table_name.singularize.foreign_key
    alias_method :orders, :comable_orders

    def initialize(*args)
      obj = args.first
      case obj.class.name
      when /Cookies/
        @cookies = obj
        super()
      else
        super
      end
    end

    def logged_in?
      !new_record?
    end

    def not_logged_in?
      !logged_in?
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
      incomplete_order.precomplete
    end

    def order(order_params = {})
      incomplete_order.attributes = order_params
      incomplete_order.complete.tap { |completed_flag| reset_cart if completed_flag }
    end

    private

    def current_guest_token
      return if logged_in?
      @cookies.signed[:guest_token]
    end

    def initialize_incomplete_order
      orders = find_incomplete_orders
      return orders.first if orders.any?
      order = orders.create(family_name: family_name, first_name: first_name, order_deliveries_attributes: [{ family_name: family_name, first_name: first_name }])
      @cookies.permanent.signed[:guest_token] = order.guest_token if not_logged_in?
      order
    end

    def find_incomplete_orders
      Comable::Order
        .incomplete
        .includes(order_deliveries: :order_details)
        .where(
          Comable::Customer.table_name.singularize.foreign_key => self,
          :guest_token => current_guest_token
        )
        .limit(1)
    end

    # Rails 3.x だと has_many 先のインスタンスが追加されても
    # 親インスタンスが感知できないので、いちいちリロードするように変更
    if Rails::VERSION::MAJOR == 3
      def add_stock_to_cart_with_reload(*args)
        add_stock_to_cart_without_reload(*args).tap { @incomplete_order = nil }
      end
      alias_method_chain :add_stock_to_cart, :reload

      def reset_stock_from_cart_with_reload(*args)
        reset_stock_from_cart_without_reload(*args).tap { @incomplete_order = nil }
      end
      alias_method_chain :reset_stock_from_cart, :reload
    end
  end
end
