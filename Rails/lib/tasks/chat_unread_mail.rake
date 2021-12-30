require "date"

namespace :chat_unread_mail do
    ChatroomUser.all.each do |chatroom_user|
        if DateTime.now - chatroom_user.last_read_at > (1/1440)
            ChatMailer.with(user_to: chatroom_user.user).chat_unread
        end 
    end
end
