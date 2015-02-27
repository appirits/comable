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
          render("#{association.to_s.singularize}_fields", ff: builder)
        end
        link_to(name, 'javascript:void(0)', options.merge(onclick: "add_fields(this, '#{association}', '#{escape_javascript(fields)}')"))
      end
    end
  end
end
