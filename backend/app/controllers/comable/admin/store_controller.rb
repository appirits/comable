require_dependency 'comable/admin/application_controller'

module Comable
  module Admin
    class StoreController < Comable::Admin::ApplicationController
      authorize_resource class: Comable::Store.name

      before_filter :find_store, only: [:show, :edit, :update]

      def show
        render :edit
      end

      def edit
      end

      def update
        if @store.update_attributes(store_params)
          redirect_to comable.admin_store_url, notice: Comable.t('successful')
        else
          flash.now[:alert] = Comable.t('failure')
          render :edit
        end
      end

      private

      def find_store
        @store = Comable::Store.instance
      end

      def store_params
        params.require(:store).permit(
          :name,
          :meta_keywords,
          :meta_description,
          :email_sender,
          :email_activate_flag
        )
      end
    end
  end
end
