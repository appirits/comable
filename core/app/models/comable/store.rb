module Comable
  class Store < ActiveRecord::Base
    include Comable::Liquidable

    belongs_to :theme, class_name: Comable::Theme.name

    validates :name, length: { maximum: 255 }
    validates :meta_keywords, length: { maximum: 255 }
    validates :meta_description, length: { maximum: 255 }
    validates :email, length: { maximum: 255 }

    liquid_methods :name, :meta_keywords, :meta_description, :email

    delegate :name, to: :theme, prefix: true, allow_nil: true

    class << self
      def instance
        first || new(name: default_name)
      end

      def default_name
        Comable.t('default_store_name')
      end
    end

    def can_send_mail?
      email.present?
    end
  end
end
