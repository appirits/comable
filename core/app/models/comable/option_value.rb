module Comable
  class OptionValue < ActiveRecord::Base
    include Comable::Ransackable

    belongs_to :option_type, class_name: Comable::OptionType.name
    has_and_belongs_to_many :variants, class_name: Comable::Variant.name, join_table: :comable_variants_option_values

    validates :name, presence: true, length: { maximum: 255 }

    default_scope { order(:option_type_id) }

    ransack_options ransackable_attributes: { only: :name }
  end
end
