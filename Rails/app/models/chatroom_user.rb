class ChatroomUser < ApplicationRecord
    belongs_to: :user, dependent: :destroy
    belongs_to: :chatroom, dependent: :destroy
end
