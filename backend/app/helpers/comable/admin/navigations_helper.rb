module Comable
  module Admin
    module NavigationsHelper
      def linkable_type_options
        Comable::NavigationItem.linkable_params_lists.map { |attr| attr.slice(:name, :type).values }
      end

      def linkable_id_options(navigation_item)
        navigation_item.linkable_class.try(:linkable_id_options) || [[]]
      end

      # アイテム追加ボタン設置
      def add_fields_button_tag(name, f, association)
        new_object = f.object.send(association).klass.new
        index = new_object.object_id # 後で置換するために必要な文字を入れる
        fields = f.fields_for(association, new_object, child_index: index) do |builder|
          render(association.to_s.singularize + '_fields', f: builder)
        end
        button_tag(name, type: :button, class: 'add_fields btn btn-default pull-right', data: { index: index, fields: fields.delete("\n") })
      end
    end
  end
end
