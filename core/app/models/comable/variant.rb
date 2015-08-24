module Comable
  class Variant < ActiveRecord::Base
    belongs_to :product, class_name: Comable::Product.name, inverse_of: :variants
    has_one :stock, class_name: Comable::Stock.name, inverse_of: :variant, dependent: :destroy, autosave: true
    has_and_belongs_to_many :option_values, class_name: Comable::OptionValue.name, dependent: :destroy, join_table: :comable_variants_option_values

    accepts_nested_attributes_for :option_values, allow_destroy: true
    accepts_nested_attributes_for :stock

    #validates :product, presence: { message: Comable.t('admin.is_not_exists') }
    validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
    validates :sku, length: { maximum: 255 }

    # refs http://stackoverflow.com/questions/8776724/how-do-i-create-a-new-object-referencing-an-existing-nested-attribute/21215218#21215218
    def option_values_attributes=(attributes)
      if attributes.is_a? Array
        existed_option_values = attributes.map do |attr|
          variant = Comable::OptionValue.find_by(option_type: attr[:option_type], name: attr[:name]) unless attr[:id]
          next unless variant
          attr[:id] = variant.id
          variant
        end.compact
        self.attributes = { option_values: existed_option_values }
      end
      super
    end
  end
end
