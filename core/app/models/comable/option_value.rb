module Comable
  class OptionValue < ActiveRecord::Base
    self.primary_key = :name

    include Comable::Ransackable

    belongs_to :option_type, class_name: Comable::OptionType.name, foreign_key: :option_type_name
    has_and_belongs_to_many :variants, class_name: Comable::Variant.name, join_table: :comable_variants_option_values, foreign_key: :option_value_name

    accepts_nested_attributes_for :option_type

    validates :name, presence: true, length: { maximum: 255 }

    ransack_options ransackable_attributes: { only: :name }
  end
end
