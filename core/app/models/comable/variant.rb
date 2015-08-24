module Comable
  class Variant < ActiveRecord::Base
    belongs_to :product, class_name: Comable::Product.name, inverse_of: :variants
    has_one :stock, class_name: Comable::Stock.name, inverse_of: :variant, dependent: :destroy, autosave: true
    has_and_belongs_to_many :option_values, class_name: Comable::OptionValue.name, dependent: :destroy, join_table: :comable_variants_option_values

    accepts_nested_attributes_for :option_values, allow_destroy: true

    #validates :product, presence: { message: Comable.t('admin.is_not_exists') }
    validates :price, presence: true, numericality: { greater_than_or_equal_to: 0, allow_blank: true }

    def code
    end

    def code=(_code)
    end

    #
    # Deprecated methods
    #
    deprecate :code, deprecator: Comable::Deprecator.instance
    deprecate :code=, deprecator: Comable::Deprecator.instance
  end
end
