module Comable
  class ShipmentMethod < ActiveRecord::Base
    validates :name, presence: true, length: { maximum: 255 }
    validates :fee, presence: true, numericality: { greater_than_or_equal_to: 0 }
    validates :traking_url, length: { maximum: 255 }

    scope :activated, -> { where(activated_flag: true) }
  end
end
