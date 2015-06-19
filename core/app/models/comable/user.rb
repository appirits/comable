module Comable
  class User < ActiveRecord::Base
    include Comable::CartOwner
    include Comable::RoleOwner
    include Comable::Ransackable
    include Comable::Liquidable

    has_many :orders, class_name: Comable::Order.name
    has_many :addresses, class_name: Comable::Address.name, dependent: :destroy
    belongs_to :bill_address, class_name: Comable::Address.name, dependent: :destroy
    belongs_to :ship_address, class_name: Comable::Address.name, dependent: :destroy

    accepts_nested_attributes_for :addresses
    accepts_nested_attributes_for :bill_address
    accepts_nested_attributes_for :ship_address

    scope :this_month, -> { where(created_at: Time.now.beginning_of_month..Time.now.end_of_month) }
    scope :this_week, -> { where(created_at: Time.now.beginning_of_week..Time.now.end_of_week) }
    scope :last_week, -> { where(created_at: 1.week.ago.beginning_of_week..1.week.ago.end_of_week) }

    validates :email, presence: true, length: { maximum: 255 }

    devise(*Comable::Config.devise_strategies[:user])

    ransack_options ransackable_attributes: { except: [:encrypted_password, :reset_password_token, :reset_password_sent_at, :remember_created_at, :bill_address_id, :ship_address_id] }

    delegate :full_name, to: :bill_address, allow_nil: true, prefix: :bill
    delegate :full_name, to: :ship_address, allow_nil: true, prefix: :ship

    def with_cookies(cookies)
      @cookies = cookies
      self
    end

    # Add conditions for the orders association.
    # Override method of the orders association to support Rails 3.x.
    def orders
      super.complete.order('completed_at DESC, id DESC')
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

    # TODO: Add a test case
    def reload(*_)
      super.tap do
        @cart_items = nil
        @incomplete_order = nil
      end
    end

    def cart_items
      incomplete_order.order_items
    end

    def incomplete_order
      @incomplete_order = nil if @incomplete_order.try(:completed?)
      @incomplete_order ||= find_incomplete_order || initialize_incomplete_order
    end

    def after_set_user
      return unless current_guest_token

      guest_order = Comable::Order.incomplete.preload(:order_items).where(guest_token: current_guest_token).first
      return unless guest_order

      incomplete_order.inherit!(guest_order)
      inherit_cart_items(guest_order)
    end

    def human_id
      "##{id}"
    end

    private

    def current_guest_token
      @cookies.signed[:guest_token] if @cookies
    end

    def initialize_incomplete_order
      order = Comable::Order.create(incomplete_order_attributes)
      @cookies.permanent.signed[:guest_token] = order.guest_token if @cookies
      # enable preload
      find_incomplete_order
    end

    def incomplete_order_attributes
      {
        user_id: id,
        email: email
      }
    end

    def find_incomplete_order
      guest_token ||= current_guest_token unless signed_in?
      Comable::Order
        .incomplete
        .preload(:order_items)
        .where(guest_token: guest_token)
        .by_user(self)
        .first
    end

    def inherit_cart_items(guest_order)
      guest_order.order_items.each do |order_item|
        move_cart_item(order_item)
      end
    end
  end
end
