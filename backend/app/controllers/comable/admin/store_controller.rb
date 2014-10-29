require_dependency 'comable/admin/application_controller'

module Comable
  module Admin
    class StoreController < Comable::Admin::ApplicationController
      # GET /admin/store
      def show
        @store = Comable::Store.first
        return redirect_to action: :new unless @store
      end

      # GET /admin/store/new
      def new
        @store = Comable::Store.new
      end

      # GET /admin/store/edit
      def edit
        @store = Comable::Store.first
      end

      # POST /admin/store
      def create
        @store = Comable::Store.new(store_params)

        if @store.save
          redirect_to comable.admin_store_url(@store), notice: 'Store was successfully created.'
        else
          render :new
        end
      end

      # PATCH/PUT /admin/store
      def update
        @store = Comable::Store.first
        if @store.update(store_params)
          redirect_to comable.admin_store_url(@store), notice: 'Store was successfully updated.'
        else
          render :edit
        end
      end

      private

      # Only allow a trusted parameter "white list" through.
      def store_params
        params.require(:store).permit(
          :name,
          :meta_keyword,
          :meta_description,
          :email_sender,
          :email_activate_flag
        )
      end
    end
  end
end
