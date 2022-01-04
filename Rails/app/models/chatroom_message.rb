# == Schema Information
#
# Table name: chatroom_messages
#
#  id          :bigint           not null, primary key
#  body        :string(255)      not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  chatroom_id :bigint
#  user_id     :bigint
#
# Indexes
#
#  index_chatroom_messages_on_chatroom_id  (chatroom_id)
#  index_chatroom_messages_on_user_id      (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (chatroom_id => chatrooms.id)
#  fk_rails_...  (user_id => users.id)
#
class ChatroomMessage < ApplicationRecord
  belongs_to :user
  belongs_to :chatroom
  has_one :activity, as: :subject, dependent: :destroy

  def create_activities(users)
    users.each do |user|
      Activity.create(subject: self, user: user, action_type: :chatmessage_me)
    end
  end

  def read_or_unread(read_time)
    confirm_read = self.created_at < read_time
    if confirm_read
      return "既読"
    else
      return "未読"
    end
  end
end
