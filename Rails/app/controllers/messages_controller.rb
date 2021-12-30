class MessagesController < ApplicationController
    before_action :require_login
    def create
        @message = current_user.chatroom_message.build(message_create)
        if @message.save
            users = Chatroom.find(params[:chatroom_id]).users_excluding(current_user)
            @message.create_activities(users)
        end
    end

    private
    def message_create
        params.require(:chatroom_message).permit(:body).merge(chatroom_id: params[:chatroom_id])
    end

end
