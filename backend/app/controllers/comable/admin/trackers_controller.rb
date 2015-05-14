require_dependency 'comable/admin/application_controller'

module Comable
  module Admin
    class TrackersController < Comable::Admin::ApplicationController
      load_and_authorize_resource class: Comable::Tracker.name

      def index
        @trackers = @trackers.page(params[:page])
      end

      def show
        render :edit
      end

      def new
      end

      def create
        if @tracker.save
          redirect_to comable.admin_tracker_path(@tracker), notice: Comable.t('successful')
        else
          flash.now[:alert] = Comable.t('failure')
          render :new
        end
      end

      def edit
      end

      def update
        if @tracker.update_attributes(tracker_params)
          redirect_to comable.admin_tracker_path(@tracker), notice: Comable.t('successful')
        else
          flash.now[:alert] = Comable.t('failure')
          render :edit
        end
      end

      def destroy
        @tracker.destroy
        redirect_to comable.admin_trackers_path, notice: Comable.t('successful')
      end

      private

      def tracker_params
        params.require(:tracker).permit(
          :activate_flag,
          :name,
          :tracker_id,
          :code,
          :place
        )
      end
    end
  end
end
