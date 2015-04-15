module Comable
  module Core
    module Configuration
      mattr_accessor :devise_strategies
      @@devise_strategies = {
        user: [:database_authenticatable, :registerable, :recoverable, :rememberable, :trackable]
      }

      mattr_accessor :products_per_page
      @@products_per_page = 15

      mattr_accessor :orders_per_page
      @@orders_per_page = 5

      mattr_accessor :export_xlsx_header_style
      @@export_xlsx_header_style = { bg_color: '00000000', fg_color: 'ffffffff', alignment: { horizontal: :center }, bold: true }

      mattr_accessor :export_xlsx_style
      @@export_xlsx_style = nil
    end
  end
end
