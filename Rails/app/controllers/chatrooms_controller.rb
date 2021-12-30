class ChatroomsController < ApplicationController
    before_action :require_login
    def index
        @chatrooms = current_user.chatrooms.includes(:users, chatroom_messages: :user).page(params[:page]).order(created_at: :desc)
    end
    
    def show
        @chatroom = current_user.chatrooms.includes(:users, :chatroom_messages).find(params[:id])
        @chatroom.set_read_datetime(current_user)
    end

    def create 
        #チャットルームがあるかを確認する
        users = User.where(id: create_chatroom_params) + [current_user]
        @chatroom = Chatroom.chatroom_for_users(users)
        redirect_to chatroom_path(@chatroom)
    end

    private
    def create_chatroom_params
        #謎の空文字が入るので最初の要素を削除する
        params.require(:chatroom).permit(user_ids: [])[:user_ids].drop(1)
    end
end
