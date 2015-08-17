module Comable
  class NavigationItem < ActiveRecord::Base
    belongs_to :navigation
    belongs_to :linkable, polymorphic: true

    acts_as_list scope: :navigation_id

    validates :navigation, presence: true, if: :navigation_id?
    validates :linkable, presence: true, if: :linkable_id?
    validates :url, presence: true, unless: :linkable_type?
    validates :url, length: { maximum: 255 }
    validates :name, length: { maximum: 255 }, presence: true
    validates :position, uniqueness: { scope: :navigation_id }

    class << self
      def linkable_params_lists
        [
          web_address_linkable_params, # Web Address
          product_linkable_params,     # Product
          page_linkable_params         # Page
        ].compact
      end

      def web_address_linkable_params
        {
          type: nil,
          name: Comable.t('admin.nav.navigation_items.web_address')
        }
      end

      def product_linkable_params
        return unless Comable::Product.linkable_exists?
        {
          type: Comable::Product.to_s,
          name: Comable.t('products')
        }
      end

      def page_linkable_params
        return unless Comable::Page.linkable_exists?
        {
          type: Comable::Page.to_s,
          name: Comable.t('pages')
        }
      end
    end

    def linkable_class
      linkable_type.constantize if linkable_type.present?
    end
  end
end
