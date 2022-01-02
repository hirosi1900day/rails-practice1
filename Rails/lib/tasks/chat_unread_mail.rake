require "date"

namespace :chat_unread_mail do
    desc "実行処理の説明"
    task chat_unread_task: :environment do
    
            (ChatroomUser.all).each do |     chatroom_user|
                    ChatMailer.with(user_to: chatroom_user.user).chat_unread.deliver_later
            end
    end
end
