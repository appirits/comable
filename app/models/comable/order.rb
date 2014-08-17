module Comable
  class Order < ActiveRecord::Base
    include Decoratable

    belongs_to :customer, class_name: Comable::Customer.name, foreign_key: Comable::Customer.table_name.singularize.foreign_key, autosave: false
    has_many :order_deliveries, dependent: :destroy, class_name: Comable::OrderDelivery.name, foreign_key: table_name.singularize.foreign_key

    accepts_nested_attributes_for :order_deliveries

    with_options if: :complete? do |complete_order|
      complete_order.validates :code, presence: true
      complete_order.validates :first_name, presence: true
      complete_order.validates :family_name, presence: true
    end

    # TODO: テストの追加
    with_options if: :incomplete? do |incomplete_order|
      incomplete_order.validates :customer, uniqueness: { scope: [:customer, :completed_at] }, if: :customer
      incomplete_order.validates :guest_token, uniqueness: { scope: [:guest_token, :completed_at] }, if: :guest_token
    end

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
      precomplete
      before_complete
      save!
      self
    end

    def complete?
      !incomplete?
    end

    def incomplete?
      completed_at.nil?
    end

    # 時価合計を取得
    def current_total_price
      order_deliveries.map(&:order_details).flatten.each(&:current_subtotal_price)
    end

    # 売価合計を取得
    def total_price
      order_deliveries.map(&:order_details).flatten.each(&:subtotal_price)
    end

    private

    def before_complete
      self.completed_at = Time.now
      generate_code
      order_deliveries.each(&:before_complete)
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
      return if customer
      self.guest_token ||= loop do
        random_token = SecureRandom.urlsafe_base64(nil, false)
        break random_token unless self.class.exists?(guest_token: random_token)
      end
    end
  end
end
