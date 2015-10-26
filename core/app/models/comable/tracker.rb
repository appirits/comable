module Comable
  class Tracker < ActiveRecord::Base
    extend Enumerize

    validates :name, presence: true, length: { maximum: 255 }
    validates :tracker_id, length: { maximum: 255 }
    validates :code, presence: true
    validates :place, presence: true, length: { maximum: 255 }

    enumerize :place, in: %i(
      everywhere
      checkout
    ), scope: true

    scope :activated, -> { where(activated_flag: true) }
    scope :by_newest, -> { reorder(created_at: :desc) }
  end
end
