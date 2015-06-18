module Comable
  module ApplicationHelper
    def current_store
      @current_store ||= Comable::Store.instance
    end

    def current_comable_user
      resource = current_admin_user || current_user || Comable::User.new
      resource.with_cookies(cookies)
    end

    def current_order
      current_comable_user.incomplete_order
    end

    def current_trackers
      @curent_trackers ||= (controller_name == 'orders' && action_name == 'create') ? Comable::Tracker.activated : Comable::Tracker.activated.with_place(:everywhere)
    end

    def next_order_path
      comable.next_order_path(state: current_order.state)
    end

    def update_order_path
      return next_order_path unless params[:state]
      comable.next_order_path(state: params[:state])
    end

    def store_location
      session[:user_return_to] = request.fullpath.gsub('//', '/')
    end

    def name_with_honorific(name)
      Comable.t('honorific', name: name)
    end

    def name_with_quantity(name, quantity)
      return name unless quantity
      return name if quantity <= 1
      [
        name,
        "x#{quantity}"
      ].join(' ')
    end

    def liquidize(content, arguments)
      string = Liquid::Template.parse(content).render(arguments.stringify_keys)
      string.respond_to?(:html_safe) ? string.html_safe : string
    end

    def set_current_meta_tags
      @current_meta_tags_params ||= current_meta_tags_params
      return if @current_meta_tags_params.blank?
      set_meta_tags @current_meta_tags_params
    end

    private

    def after_sign_in_path_for(_resource)
      session.delete(:user_return_to) || comable.root_path
    end

    def after_sign_out_path_for(_resource)
      session.delete(:user_return_to) || comable.root_path
    end

    def after_sign_up_path_for(resource)
      signed_in_root_path(resource) || comable.root_path
    end

    def after_update_path_for(resource)
      signed_in_root_path(resource) || comable.root_path
    end

    def after_resetting_password_path_for(resource)
      signed_in_root_path(resource) || comable.root_path
    end

    def current_meta_tags_params
      return unless current_resource
      return unless current_resource.respond_to?(:meta_tags_params)
      current_resource.meta_tags_params.presence
    end

    def current_resource
      instance_variable_get current_resource_name
    end

    def current_resource_name
      "@#{controller.controller_name.singularize}"
    end
  end
end
