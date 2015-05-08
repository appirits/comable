module Comable
  class Order < ActiveRecord::Base
    include Comable::Checkout
    include Comable::Ransackable
    include Comable::Order::Morrisable

    belongs_to :user, class_name: Comable::User.name, autosave: false
    belongs_to :payment_method, class_name: Comable::PaymentMethod.name, autosave: false
    belongs_to :bill_address, class_name: Comable::Address.name, autosave: true, dependent: :destroy
    belongs_to :ship_address, class_name: Comable::Address.name, autosave: true, dependent: :destroy
    has_many :order_items, dependent: :destroy, class_name: Comable::OrderItem.name, inverse_of: :order
    has_one :shipment, dependent: :destroy, class_name: Comable::Shipment.name, inverse_of: :order

    accepts_nested_attributes_for :bill_address
    accepts_nested_attributes_for :ship_address
    accepts_nested_attributes_for :order_items
    accepts_nested_attributes_for :shipment

    define_model_callbacks :complete
    before_validation :generate_guest_token, on: :create
    before_validation :clone_addresses_from_user, on: :create
    before_complete :generate_code
    after_complete :clone_addresses_to_user

    scope :complete, -> { where.not(completed_at: nil) }
    scope :incomplete, -> { where(completed_at: nil) }
    scope :by_user, -> (user) { where(user_id: user) }
    scope :this_month, -> { where(completed_at: Time.now.beginning_of_month..Time.now.end_of_month) }
    scope :this_week, -> { where(completed_at: Time.now.beginning_of_week..Time.now.end_of_week) }
    scope :last_week, -> { where(completed_at: 1.week.ago.beginning_of_week..1.week.ago.end_of_week) }
    scope :recent, -> { order('completed_at DESC, id DESC') }

    validates :user_id, uniqueness: { scope: :completed_at }, if: :user
    validates :guest_token, presence: true, uniqueness: { scope: :completed_at }, unless: :user

    ransack_options attribute_select: { associations: :shipment }, ransackable_attributes: { except: [:payment_method_id, :bill_address_id, :ship_address_id] }

    delegate :full_name, to: :bill_address, allow_nil: true, prefix: :bill
    delegate :full_name, to: :ship_address, allow_nil: true, prefix: :ship
    delegate :state, :human_state_name, to: :shipment, allow_nil: true, prefix: true

    alias_method :completed?, :complete?

    def complete!
      ActiveRecord::Base.transaction do
        run_callbacks :complete do
          self.shipment_fee = current_shipment_fee
          self.total_price = current_total_price
          order_items.each(&:complete)
          save!

          shipment.next_state! if shipment

          touch(:completed_at)
        end
      end
    end

    alias_method :complete, :complete!
    deprecate :complete, deprecator: Comable::Deprecator.instance

    def restock!
      order_items.each(&:restock)
      save!
    end

    def unstock!
      order_items.each(&:unstock)
      save!
    end

    def stocked_items
      order_items.to_a.select(&:unstocked?)
    end

    # 時価商品合計を取得
    def current_item_total_price
      order_items.to_a.sum(&:current_subtotal_price)
    end

    # 売価商品合計を取得
    def item_total_price
      order_items.to_a.sum(&:subtotal_price)
    end

    # 時価送料を取得
    def current_shipment_fee
      shipment.try(:fee) || 0
    end

    # 時価合計を取得
    def current_total_price
      current_item_total_price + current_shipment_fee
    end

    # Inherit from other Order
    def inherit!(order)
      self.bill_address ||= order.bill_address
      self.ship_address ||= order.ship_address
      self.shipment ||= order.shipment
      self.payment_method ||= order.payment_method

      stated?(order.state) ? save! : next_state!
    end

    private

    def generate_code
      self.code = loop do
        random_token = "C#{Array.new(11) { rand(9) }.join}"
        break random_token unless self.class.exists?(code: random_token)
      end
    end

    def generate_guest_token
      return if user
      self.guest_token ||= loop do
        random_token = SecureRandom.urlsafe_base64(nil, false)
        break random_token unless self.class.exists?(guest_token: random_token)
      end
    end

    def clone_addresses_from_user
      return unless user
      self.bill_address ||= user.bill_address.try(:clone)
      self.ship_address ||= user.ship_address.try(:clone)
    end

    def clone_addresses_to_user
      return unless user
      user.update_bill_address_by bill_address
      user.update_ship_address_by ship_address
    end
  end
end
