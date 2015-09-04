module Comable
  class OptionType < ActiveRecord::Base
    include Comable::Ransackable

    has_many :option_values, class_name: Comable::OptionValue.name

    validates :name, presence: true, length: { maximum: 255 }

    ransack_options ransackable_attributes: { only: :name }

    def values
      @values ? @values : option_values.map(&:name)
    end

    def values=(values)
      @values = values.is_a?(String) ? values.split(' ') : values
    end
  end
end
