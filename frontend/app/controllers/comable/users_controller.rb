module Comable
  class UsersController < Comable::ApplicationController
    include Comable::PermittedAttributes

    before_filter :authenticate_user!

    def show
      @orders = current_user.orders.page(params[:page]).per(Comable::Config.orders_per_page)
    end

    def update_addresses
      current_user.attributes = user_params
      if current_user.save
        flash.now[:notice] = Comable.t('successful')
      else
        flash.now[:alert] = Comable.t('failure')
      end
      render :addresses
    end

    def user_params
      params.require(:user).permit(
        :bill_address_id,
        :ship_address_id,
        addresses_attributes: permitted_address_attributes
      )
    end
  end
end
