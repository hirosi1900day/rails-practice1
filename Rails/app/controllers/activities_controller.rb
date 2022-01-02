class ActivitiesController < ApplicationController
    def read 
        activity = Activity.find(params[:id])
        activity.read! if activity.unread?
        redirect_to activity.redirect_path
    end

    def index
        @activities = Activity.all.order(created_at: :desc)
    end

end
