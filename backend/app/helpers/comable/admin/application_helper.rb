module Comable
  module Admin
    module ApplicationHelper
      def link_to_save
        link_to Comable.t('admin.actions.save'), 'javascript:$("form").submit()', class: 'btn btn-primary'
      end
    end
  end
end
