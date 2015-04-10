module Comable
  module ApplicationHelper
    def current_store
      @current_store ||= Comable::Store.instance
    end

    # Override the devise method.
    # The below codes move to core/lib/comable/core/engine.rb:
    #
    # def current_user
    #   ...
    # end

    def current_order
      current_user.incomplete_order
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
  end
end
