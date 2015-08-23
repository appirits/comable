module Comable
  module ApplicationHelper
    def current_store
      @current_store ||= Comable::Store.instance
    end

    def current_comable_user
      resource = current_admin_user if defined? Comable::Backend
      resource ||= current_user if defined? Comable::Frontend
      resource ||= Comable::User.new
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

    # To use the functionality of liquid-rails
    def liquid_assigns
      view_context.assigns.merge(
        current_store: current_store,
        current_comable_user: current_comable_user,
        current_order: current_order,
        current_trackers: current_trackers,
        form_authenticity_token: form_authenticity_token
      ).stringify_keys
    end

    private

    def comable_root_path
      case resource_name
      when :admin_user
        comable.admin_root_path
      else
        defined?(Comable::Frontend) ? comable.root_path : '/'
      end
    end

    def after_sign_in_path_for(_resource_or_scope)
      session.delete(:user_return_to) || comable_root_path
    end

    def after_sign_out_path_for(_scope)
      session.delete(:user_return_to) || comable_root_path
    end

    def after_sign_up_path_for(resource)
      signed_in_root_path(resource) || comable_root_path
    end

    def after_update_path_for(resource)
      signed_in_root_path(resource) || comable_root_path
    end

    def after_resetting_password_path_for(resource)
      signed_in_root_path(resource) || comable_root_path
    end
  end
end
