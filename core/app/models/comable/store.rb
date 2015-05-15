module Comable
  class Store < ActiveRecord::Base
    validates :name, length: { maximum: 255 }
    validates :meta_keywords, length: { maximum: 255 }
    validates :meta_description, length: { maximum: 255 }
    validates :email_sender, length: { maximum: 255 }

    class << self
      def instance
        first || new(name: default_name)
      end

      def default_name
        'Comable store'
      end
    end

    def email_activate?
      email_sender.present?
    end
  end
end
