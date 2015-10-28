module Comable
  class StockLocation < ActiveRecord::Base
    has_many :shipments, class_name: Comable::Shipment.name
    has_many :stocks, class_name: Comable::Stock.name, dependent: :destroy
    belongs_to :address, class_name: Comable::Address.name

    accepts_nested_attributes_for :address

    validates :name, presence: true, length: { maximum: 255 }

    scope :active, -> { where(active: true) }

    class << self
      def default
        where(default: true).first
      end
    end

    def as_json(_options = {})
      { id: id, text: name }
    end

    def find_stock_item(variant)
      stocks.find_by(variant: variant)
    end
  end
end
