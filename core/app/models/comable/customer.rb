module Comable
  class Customer < ActiveRecord::Base
    include CartOwner

    has_many :orders, class_name: Comable::Order.name, foreign_key: table_name.singularize.foreign_key
    has_many :addresses, class_name: Comable::Address.name, foreign_key: table_name.singularize.foreign_key, dependent: :destroy
    belongs_to :bill_address, class_name: Comable::Address.name, dependent: :destroy
    belongs_to :ship_address, class_name: Comable::Address.name, dependent: :destroy

    accepts_nested_attributes_for :addresses
    accepts_nested_attributes_for :bill_address
    accepts_nested_attributes_for :ship_address

    devise(*Comable::Config.devise_strategies[:customer])

    before_save :inherit_cart_items, if: :current_sign_in_at_changed?

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

    def update_bill_address_by(bill_address)
      update_attributes(bill_address: addresses.find_or_clone(bill_address))
    end

    def update_ship_address_by(ship_address)
      update_attributes(ship_address: addresses.find_or_clone(ship_address))
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
      # enable includes
      find_incomplete_orders.first
    end

    def incomplete_order_attributes
      {
        self.class.table_name.singularize.foreign_key => id,
        email: email,
        # TODO: Remove
        family_name: family_name,
        first_name: first_name,
        order_deliveries_attributes: [{ family_name: family_name, first_name: first_name }]
      }
    end

    def find_incomplete_orders
      guest_token = current_guest_token unless signed_in?
      Comable::Order
        .incomplete
        .includes(order_deliveries: :order_details)
        .where(guest_token: guest_token)
        .by_customer(self)
        .limit(1)
    end

    def inherit_cart_items
      return unless current_guest_token
      guest_order = Comable::Order.incomplete.includes(order_deliveries: :order_details).where(guest_token: current_guest_token).first
      return unless guest_order
      guest_order.order_deliveries.map(&:order_details).flatten.each do |order_detail|
        move_cart_item(order_detail)
      end
      # TODO: Remove?
      cart_items.reload
    end
  end
end
