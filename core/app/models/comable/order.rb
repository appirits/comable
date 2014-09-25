module Comable
  class Order < ActiveRecord::Base
    belongs_to :customer, class_name: Comable::Customer.name, foreign_key: Comable::Customer.table_name.singularize.foreign_key, autosave: false
    belongs_to :payment, class_name: Comable::Payment.name, foreign_key: Comable::Payment.table_name.singularize.foreign_key, autosave: false
    belongs_to :shipment_method, class_name: Comable::ShipmentMethod.name, autosave: false
    has_many :order_deliveries, dependent: :destroy, class_name: Comable::OrderDelivery.name, foreign_key: table_name.singularize.foreign_key

    accepts_nested_attributes_for :order_deliveries

    with_options if: :complete? do |complete_order|
      complete_order.validates :code, presence: true
      complete_order.validates :first_name, presence: true
      complete_order.validates :family_name, presence: true
      complete_order.validates :shipment_fee, presence: true
      complete_order.validates :total_price, presence: true
    end

    with_options if: :incomplete? do |incomplete_order|
      incomplete_order.validates Comable::Customer.table_name.singularize.foreign_key, uniqueness: { scope: [Comable::Customer.table_name.singularize.foreign_key, :completed_at] }, if: :customer
      incomplete_order.validates :guest_token, uniqueness: { scope: [:guest_token, :completed_at] }, if: :guest_token
    end

    define_model_callbacks :complete
    before_complete :precomplete
    before_create :generate_guest_token

    scope :complete, -> { where.not(completed_at: nil) }
    scope :incomplete, -> { where(completed_at: nil) }

    def precomplete
      valid_stock
      fail Comable::InvalidOrder, errors.full_messages.join("\n") if errors.any?
      self
    end

    def complete
      # TODO: トランザクションの追加
      run_callbacks :complete do
        save_to_complete!
      end
      self
    end

    def complete?
      !incomplete?
    end

    def incomplete?
      completed_at.nil?
    end

    # 時価商品合計を取得
    def current_item_total_price
      order_deliveries.map(&:order_details).flatten.sum(&:current_subtotal_price)
    end

    # 売価商品合計を取得
    def item_total_price
      order_deliveries.map(&:order_details).flatten.sum(&:subtotal_price)
    end

    # 時価送料を取得
    def current_shipment_fee
      shipment_method.try(:fee) || 0
    end

    # 時価合計を取得
    def current_total_price
      current_item_total_price + current_shipment_fee
    end

    private

    def save_to_complete!
      self.completed_at = Time.now
      self.shipment_fee = current_shipment_fee
      self.total_price = current_total_price
      generate_code
      order_deliveries.each(&:save_to_complete)
      save!
    end

    def valid_stock
      order_deliveries.map(&:order_details).flatten.each do |order_detail|
        return errors.add :base, "「#{order_detail.stock.name}」の注文数が不正です。" if order_detail.quantity <= 0
        quantity = order_detail.stock.quantity - order_detail.quantity
        return errors.add :base, "「#{order_detail.stock.name}」の在庫が不足しています。" if quantity < 0
      end
    end

    def generate_code
      self.code = loop do
        random_token = "C#{Array.new(11) { rand(9) }.join}"
        break random_token unless self.class.exists?(code: random_token)
      end
    end

    def generate_guest_token
      return if send(Comable::Customer.table_name.singularize.foreign_key)
      self.guest_token ||= loop do
        random_token = SecureRandom.urlsafe_base64(nil, false)
        break random_token unless self.class.exists?(guest_token: random_token)
      end
    end
  end
end
