module Comable
  class Address < ActiveRecord::Base
    belongs_to :customer, class_name: Comable::Customer.name, foreign_key: Comable::Customer.table_name.singularize.foreign_key, autosave: false

    validates :family_name, presence: true, length: { maximum: 255 }
    validates :first_name, presence: true, length: { maximum: 255 }
    validates :zip_code, presence: true, length: { maximum: 8 }
    validates :state_name, presence: true, length: { maximum: 255 }
    validates :city, presence: true, length: { maximum: 255 }
    validates :detail, length: { maximum: 255 }
    validates :phone_number, length: { maximum: 18 }
  end
end
