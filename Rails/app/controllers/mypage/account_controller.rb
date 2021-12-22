class Mypage::AccountController < ApplicationController
    before_action :require_login
    def edit
        if current_user.id.to_s == params[:id].to_s
            return @user = current_user
        end
    end
    
    def create 
        current_user.update(update_params)
    end

    private
    def update_params
        params.require(:user).permit(:name, :avatar)
    end

end
