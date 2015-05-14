module Comable
  class Tracker < ActiveRecord::Base
    extend Enumerize

    validates :name, presence: true, length: { maximum: 255 }
    validates :tracker_id, length: { maximum: 255 }
    validates :code, presence: true
    validates :place, presence: true, length: { maximum: 255 }

    scope :activated, -> { where(activate_flag: true) }

    enumerize :place, in: %i(
      everywhere
      checkout
    ), scope: true
  end
end
