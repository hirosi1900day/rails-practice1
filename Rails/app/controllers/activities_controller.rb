class ActivitiesController < ApplicationController
    def read 
        activity = Activity.find(params[:id])
        activity.read! if activity.unread?
        redirect_to activity.redirect_path
    end

end
