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
