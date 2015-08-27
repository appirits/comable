module Comable
  class OptionType < ActiveRecord::Base
    include Comable::Ransackable

    has_many :option_values, class_name: Comable::OptionValue.name
    belongs_to :product, class_name: Comable::Product.name, inverse_of: :option_types, autosave: true

    validates :product, presence: { message: Comable.t('admin.is_not_exists') }
    validates :name, presence: true, length: { maximum: 255 }

    default_scope { order(:id) }

    ransack_options ransackable_attributes: { only: :name }

    def values
      @values ? @values : option_values.map(&:name)
    end

    def values=(values)
      @values = values.is_a?(String) ? values.split(' ') : values
    end
  end
end
