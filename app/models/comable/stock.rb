module Comable
  class Stock < ActiveRecord::Base
    include Decoratable

    belongs_to :product, class_name: Comable::Product.name, foreign_key: Comable::Product.table_name.singularize.foreign_key

    scope :activated, -> { where.not(product_id_num: nil) }
    scope :unsold, -> { where('quantity > ?', 0) }
    scope :soldout, -> { where('quantity <= ?', 0) }

    delegate :price, to: :product
    delegate :sku?, to: :product

    def name
      return product.name unless product.sku?
      sku_name = sku_h_choice_name
      sku_name += '/' + sku_v_choice_name if sku_v_choice_name.present?
      product.name + "(#{sku_name})"
    end

    def unsold?
      return false if product_id_num.nil?
      return false if quantity.nil?
      quantity > 0
    end

    def soldout?
      !unsold?
    end

    def decrement_quantity!(quantity: 1)
      with_lock do
        # TODO: カラムマッピングのdecrementメソッドへの対応
        self.quantity -= quantity
        save!
      end
    end
  end
end
