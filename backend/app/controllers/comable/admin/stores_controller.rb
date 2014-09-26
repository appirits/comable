require_dependency 'comable/admin/application_controller'

module Comable
  module Admin
    class StoresController < ApplicationController
      # GET /admin/stores
      def index
        @stores = Comable::Store.all
      end

      # GET /admin/stores/1
      def show
        @store = Comable::Store.find(params[:id])
      end

      # GET /admin/stores/new
      def new
        @store = Comable::Store.new
      end

      # GET /admin/stores/1/edit
      def edit
        @store = Comable::Store.find(params[:id])
      end

      # POST /admin/stores
      def create
        @store = Comable::Store.new(store_params)

        if @store.save
          redirect_to comable.admin_store_url(@store), notice: 'Store was successfully created.'
        else
          render :new
        end
      end

      # PATCH/PUT /admin/stores/1
      def update
        @store = Comable::Store.find(params[:id])
        if @store.update(store_params)
          redirect_to comable.admin_store_url(@store), notice: 'Store was successfully updated.'
        else
          render :edit
        end
      end

      # DELETE /admin/stores/1
      def destroy
        @store = Comable::Store.find(params[:id])
        @store.destroy
        redirect_to comable.admin_stores_url, notice: 'Store was successfully destroyed.'
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
