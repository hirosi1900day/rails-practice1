# == Schema Information
#
# Table name: chatrooms
#
#  id         :bigint           not null, primary key
#  name       :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Chatroom < ApplicationRecord
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
    end

    def users_excluding(user)
        users.reject { |u| u == user }
    end
    
    def set_read_datetime(user)
        self.chatroom_users.find_by(user_id: user.id).update(last_read_at: Time.now)
    end
end
