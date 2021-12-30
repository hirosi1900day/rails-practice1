class Mypage::NotificationSettingsController < ApplicationController
    before_action :require_login
    def edit 
        @user = User.find(current_user.id)
    end

    def update 
        if current_user.update(notification_setting_params)
            flash.now[:success] = '設定を更新しました'
            render :edit
        end
    end

    private 

    def notification_setting_params
        params.require(:user).permit(:notification_on_comment, :notification_on_like, :notification_on_follow)
    end

end
