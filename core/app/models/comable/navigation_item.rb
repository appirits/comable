module Comable
  class NavigationItem < ActiveRecord::Base
    include Comable::Linkable

    belongs_to :navigation
    belongs_to :linkable, polymorphic: true

    acts_as_list scope: :navigation

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

      def linkable_id_options(type)
        params = linkable_params(type)
        params ? params[:linkable_id_options] : [[]]
      end

      private

      def linkable_params(type)
        linkable_params_lists.find do |params|
          params[:type].to_s == type.to_s
        end
      end

      def web_address_linkable_params
        {
          type: nil,
          name: Comable.t('admin.nav.navigation_items.web_address'),
          linkable_id_options: [[]]
        }
      end

      def product_linkable_params
        {
          type: Comable::Product.to_s,
          name: Comable.t('products'),
          linkable_id_options: calc_linkable_id_options(Comable::Product, use_index: true)
        }
      end

      def page_linkable_params
        {
          type: Comable::Page.to_s,
          name: Comable.t('pages'),
          linkable_id_options: calc_linkable_id_options(Comable::Page, name: :title)
        }
      end
    end

    def linkable_class
      linkable_type.constantize if linkable_type.present?
    end

    def linkable_id_options
      self.class.linkable_id_options(linkable_type)
    end

    def linkable_exists?
      linkable_id_options.all?(&:present?)
    end
  end
end
