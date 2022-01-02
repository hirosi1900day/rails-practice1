class ChatMailer < ApplicationMailer
    def chat_unread  
        @user_to = params[:user_to]
        mail(to: @user_to.email, subject: "未読のメッセージがあります")  
    end
end