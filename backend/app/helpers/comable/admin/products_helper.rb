module Comable
  module Admin
    module ProductsHelper
      # プロパティ追加ボタン設置
      def add_property_button_tag(name)
        fields = render 'comable/admin/products/property_fields', key: nil, value: nil
        button_tag(name, type: :button, class: 'add_property btn btn-default pull-right', data: { fields: fields.delete("\n") })
      end
    end
  end
end
