module Comable
  class Variant < ActiveRecord::Base
    include Comable::Ransackable

    belongs_to :product, class_name: Comable::Product.name, inverse_of: :variants
    has_one :stock, class_name: Comable::Stock.name, inverse_of: :variant, dependent: :destroy, autosave: true

    has_and_belongs_to_many :option_values, class_name: Comable::OptionValue.name, join_table: :comable_variants_option_values

    accepts_nested_attributes_for :option_values, allow_destroy: true
    accepts_nested_attributes_for :stock

    validates :product, presence: { message: Comable.t('admin.is_not_exists') }
    validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
    validates :sku, length: { maximum: 255 }

    ransack_options attribute_select: { associations: [:product, :stock, :option_values] }, ransackable_attributes: { except: :product_id }

    def quantity
      stock.try(:quantity) || build_stock.quantity
    end

    def quantity=(quantity)
      if stock
        stock.quantity = quantity
      else
        build_stock(quantity: quantity)
      end
    end

    def options
      option_values.map do |option_value|
        OpenStruct.new(type: option_value.option_type.try(:name), value: option_value.name)
      end
    end

    def options=(options)
      options = JSON.parse(options) if options.is_a? String
      self.option_values = options.map do |option|
        hash = option.symbolize_keys
        option_type = Comable::OptionType.where(name: hash[:name]).first_or_initialize(&:save!)
        Comable::OptionValue.where(name: hash[:value], option_type: option_type).first_or_initialize(&:save!)
      end
    end
  end
end
