require_dependency 'comable/admin/application_controller'

module Comable
  module Admin
    class UsersController < Comable::Admin::ApplicationController
      include Comable::PermittedAttributes

      load_and_authorize_resource class: Comable::User.name, except: :index

      def index
        @q = Comable::User.ransack(params[:q])
        @users = @q.result.page(params[:page]).accessible_by(current_ability).by_newest

        respond_to do |format|
          format.html
          format.json { render json: @users }
        end
      end

      def show
      end

      def edit
      end

      def update
        if @user.update_attributes(user_params)
          redirect_to comable.admin_user_path(@user), notice: Comable.t('successful')
        else
          flash.now[:alert] = Comable.t('failure')
          render :edit
        end
      end

      def profile
        @user = current_comable_user
        render :edit
      end

      private

      def user_params
        params.require(:user).permit(
          :email,
          :password,
          :role,
          bill_address_attributes: permitted_address_attributes
        )
      end
    end
  end
end
