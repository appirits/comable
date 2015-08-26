module Comable
  class OptionType < ActiveRecord::Base
    has_many :option_values, class_name: Comable::OptionValue.name
    belongs_to :product, class_name: Comable::Product.name

    validates :name, presence: true, length: { maximum: 255 }

    default_scope { order(:id) }

    def values
      option_values.map(&:name)
    end

    def values=(values)
      values = values.split(' ') if values.is_a? String
      self.option_values = values.map do |value|
        value.is_a?(Comable::OptionValue) ? value : option_values.where(name: value).first_or_initialize
      end
    end
  end
end
