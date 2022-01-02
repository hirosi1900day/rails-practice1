class ChatroomDecorator < Draper::Decorator
  delegate_all

  def message_text 
    chatroom_messages.last&.body&.truncate(30) || 'メッセージがまだありません'
  end
end
