module Comable
  module Admin
    module ApplicationHelper
      def link_to_save
        link_to Comable.t('admin.actions.save'), 'javascript:$("form").submit()', class: 'btn btn-primary'
      end

      def gravatar_tag(email, options = {})
        hash = Digest::MD5.hexdigest(email)
        image_tag "//www.gravatar.com/avatar/#{hash}?default=mm", options
      end

      def link_to_add_fields(name, f, association, options = {})
        new_object = f.object.class.reflect_on_association(association).klass.new
        fields = f.fields_for(association, new_object, child_index: "new_#{association}") do |builder|
          render("comable/admin/shared/#{association.to_s.singularize}_fields", ff: builder)
        end
        link_to(name, 'javascript:void(0)', options.merge(onclick: "add_fields(this, '#{association}', '#{escape_javascript(fields)}')"))
      end

      def button_to_remove_fields(name, options = {})
        content_tag(:button, name, options.merge(class: "remove_fields #{options[:class]}"))
      end

      def button_to_add_fields(name, f, type, options = {})
        new_fields = build_fields(f, type)
        content_tag(:button, name, options.merge(class: "add_fields #{options[:class]}", 'data-field-type' => type, 'data-content' => "#{new_fields}"))
      end

      def build_fields(f, type)
        render_block = -> (builder) { render("comable/admin/shared/#{type}_fields", f: builder) }

        if singular? type
          new_object = f.object.send("build_#{type}")
          f.send("#{type}_fields", new_object, child_index: "new_#{type}", &render_block)
        else
          new_object = f.object.send(type).klass.new
          f.send('fields_for', type, new_object, child_index: "new_#{type}", &render_block)
        end
      end

      def enable_advanced_search?
        grouping_params = params[:q][:g]
        conditions_params = grouping_params.values.first[:c]
        value_params = conditions_params.values.first[:v]

        value_params.values.first[:value].present?
      rescue NoMethodError
        false
      end

      def page_name
        [controller_name, action_name].join(':')
      end

      private

      def singular?(string)
        string.to_s.try(:singularize) == string.to_s
      end
    end
  end
end
