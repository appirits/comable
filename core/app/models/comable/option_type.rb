module Comable
  class OptionType < ActiveRecord::Base
    has_many :option_values, class_name: Comable::OptionValue.name
    belongs_to :product, class_name: Comable::Product.name

    validates :name, presence: true, length: { maximum: 255 }

    default_scope { order(:id) }
  end
end
