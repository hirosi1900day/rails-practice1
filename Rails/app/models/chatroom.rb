class ChatRoom < ApplicationRecord
    has_many :chatroom_messages, dependent: :destroy
    has_many :chatroom_users, dependent: :destroy
    has_many :users, through: :chatroom_users

    def self.chatroom_for_users(users)
        name = users.map(&:id).sort.join(":").to_s
        unless (chatroom = find_by(name: name))
            chatroom = new(name: name)
            chatroom.users = users
            chatroom.save
        end
        chatroom
    end

    def users_excluding(user)
        users.reject { |u| u == user }
    end
end
