require_dependency 'comable/admin/application_controller'

module Comable
  module Admin
    class NavigationsController < Comable::Admin::ApplicationController
      load_and_authorize_resource class: Comable::Navigation.name, except: :index

      def index
        @q = Comable::Navigation.ransack(params[:q])
        @navigations = @q.result.accessible_by(current_ability)
      end

      def show
        edit
        render :edit
      end

      def new
        @navigation.navigation_items.build
      end

      def edit
      end

      def create
        @navigation = Comable::Navigation.new(navigation_params)
        if @navigation.save
          redirect_to comable.admin_navigation_path(@navigation), notice: Comable.t('successful')
        else
          render :new
        end
      end

      def update
        @navigation.attributes = navigation_params
        if @navigation.save
          redirect_to comable.admin_navigation_path(@navigation), notice: Comable.t('successful')
        else
          render :edit
        end
      end

      def destroy
        @navigation.destroy
        redirect_to comable.admin_navigations_path, notice: Comable.t('successful')
      end

      def search_linkable_ids
        fail unless request.xhr?
        fail unless request.post?
        @linkable_id_options = linkable_id_options
        render layout: false
      end

      private

      def linkable_type
        params[:linkable_type] if Comable.const_defined?(params[:linkable_type].demodulize)
      end

      def linkable_id_options
        linkable_type ? linkable_type.constantize.linkable_id_options : [[]]
      end

      def navigation_params
        params.require(:navigation).permit(
          :name,
          navigation_items_attributes: navigation_items_attributes_keys
        )
      end

      def navigation_items_attributes_keys
        [
          :id,
          :position,
          :linkable_id,
          :linkable_type,
          :name,
          :url,
          :_destroy
        ]
      end
    end
  end
end
