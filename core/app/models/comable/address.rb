module Comable
  class Address < ActiveRecord::Base
    belongs_to :customer, class_name: Comable::Customer.name, autosave: false

    validates :family_name, presence: true, length: { maximum: 255 }
    validates :first_name, presence: true, length: { maximum: 255 }
    validates :zip_code, presence: true, length: { maximum: 8 }
    validates :state_name, presence: true, length: { maximum: 255 }
    validates :city, presence: true, length: { maximum: 255 }
    validates :detail, length: { maximum: 255 }
    validates :phone_number, length: { maximum: 18 }

    class << self
      def find_or_clone(address)
        find { |obj| obj.same_as? address } || address.clone
      end
    end

    def same_as?(address)
      attributes_without_id == address.attributes_without_id
    end

    def clone
      self.class.new(attributes_without_id)
    end

    def attributes_without_id
      attributes.except('id', 'customer_id')
    end

    def full_name
      "#{family_name} #{first_name}"
    end
  end
end
