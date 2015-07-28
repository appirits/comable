module Comable
  class Navigation < ActiveRecord::Base
    include Comable::Ransackable

    has_many :navigation_items

    accepts_nested_attributes_for :navigation_items, allow_destroy: true

    validates :name, length: { maximum: 255 }, presence: true
    validates :navigation_items, presence: true
  end
end
