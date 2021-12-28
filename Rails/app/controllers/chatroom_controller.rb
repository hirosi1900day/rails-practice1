class ChatroomController < ApplicationController
    before_action :require_login
    def index
        @chatrooms = current_user.chatrooms.includes(:users, chatroom_message: :user).order(created_at: :desc).page(params[:page])
    end
    
    def show
        @chatroom = current_user.chatrooms.find(params[:id]).includes(:users, chatroom_message: :user).order(created_at: :desc)
    end

    def create 
        #チャットルームがあるかを確認する
        users = User.where(id: create_chatroom_params) + [current_user]
        @chatroom = ChatRoom.chatroom_for_users(users)
        redirect_to chatroom_path(@chatroom)
    end

    private
    def create_chatroom_params
        params.require(:chatroom).permit(user_ids: [])
    end
end
