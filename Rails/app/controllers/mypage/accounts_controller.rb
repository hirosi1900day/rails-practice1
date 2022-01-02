class Mypage::AccountsController < ApplicationController
    before_action :require_login
    def edit
        @user = current_user
    end
    
    def create 
        current_user.update(update_params)
    end

    private
    def update_params
        params.require(:user).permit(:name, :avatar)
    end
end
