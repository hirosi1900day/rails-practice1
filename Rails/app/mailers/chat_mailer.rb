class ChatMailer < ApplicationMailer
    def chat_unread  
        @user_to   = params[:user_to]
        @post      = params[:post]
        mail(to: @user_to.email, subject: "#{@user_from.name}があなたの投稿にいいねしました。")  
    end
