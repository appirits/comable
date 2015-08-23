module Comable
  class OptionValue < ActiveRecord::Base
    belongs_to :option_type, class_name: Comable::OptionType.name
    has_and_belongs_to_many :variants, class_name: Comable::Variant.name, join_table: :comable_variants_option_values
  end
end
