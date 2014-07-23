module Comable
  module Stockable
    def self.included(base)
      base.instance_eval do
        belongs_to :product, class_name: Comable::Product.name, foreign_key: Comable::Product.name.foreign_key

        scope :activated, -> { where.not(product_id_num: nil) }
        scope :unsold, -> { where('quantity > ?', 0) }
        scope :soldout, -> { where('quantity <= ?', 0) }

        delegate :price, to: :product
        delegate :sku?, to: :product
      end
    end

    def unsold?
      return false if product_id_num.nil?
      return false if quantity.nil?
      quantity > 0
    end

    def soldout?
      !unsold?
    end

    def decrement_quantity!
      ActiveRecord::Base.transaction do
        # TODO: カラムマッピングのdecrementメソッドへの対応
        update_attributes(quantity: quantity.pred)
      end
    end
  end
end
