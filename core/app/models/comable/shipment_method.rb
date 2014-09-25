module Comable
  class ShipmentMethod < ActiveRecord::Base
    scope :activated, -> { where(activate_flag: true) }
    scope :deactivated, -> { where(activate_flag: false) }
  end
end
