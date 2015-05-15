module Comable
  class Address < ActiveRecord::Base
    belongs_to :user, class_name: Comable::User.name, autosave: false

    validates :family_name, presence: true, length: { maximum: 255 }
    validates :first_name, presence: true, length: { maximum: 255 }
    validates :zip_code, presence: true, length: { maximum: 8 }
    validates :state_name, presence: true, length: { maximum: 255 }
    validates :city, presence: true, length: { maximum: 255 }
    validates :detail, length: { maximum: 255 }
    validates :phone_number, length: { maximum: 18 }

    class << self
      def find_or_clone(address)
        all.to_a.find { |obj| obj.same_as? address } || address.clone
      end
    end

    def same_as?(address)
      contents == address.contents
    end

    def clone
      self.class.new(contents)
    end

    def contents
      attributes.except('id', 'user_id', 'created_at', 'updated_at')
    end

    def full_name
      "#{family_name} #{first_name}"
    end

    def full_address
      "#{state_name} #{city} #{detail}"
    end
  end
end
