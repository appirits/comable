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
    end
  end
end
