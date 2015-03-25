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

      def setup_search_form(builder)
        %Q{
          <script type="text/javascript">
            jQuery(document).ready(function() {
              var search = new Search();

              $(document).on("click", ".ransack.add_fields", function() {
                search.add_fields(this, $(this).data('fieldType'), $(this).data('content'));
                return false;
              });

              $(document).on("click", ".ransack.remove_fields", function() {
                search.remove_fields(this);
                return false;
              });
            });
          </script>
        }.html_safe
      end

      def button_to_remove_fields(name, options = {})
        content_tag(:button, name, options.merge(class: "ransack remove_fields #{options[:class]}"))
      end

      def button_to_add_fields(name, f, type, options = {})
        new_fields = build_fields(f, type)
        content_tag(:button, name, options.merge(class: "ransack add_fields #{options[:class]}", 'data-field-type' => type, 'data-content' => "#{new_fields}"))
      end

      def build_fields(f, type)
        new_object = f.object.send("build_#{type}")

        f.send("#{type}_fields", new_object, child_index: "new_#{type}") do |builder|
          render("comable/admin/shared/#{type}_fields", f: builder)
        end
      end

      def enable_advanced_search?
        params[:q] && params[:q][:g]
      end
    end
  end
end
