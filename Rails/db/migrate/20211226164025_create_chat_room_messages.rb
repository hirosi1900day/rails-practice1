class CreateChatRoomMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :chatroom_messages do |t|
      t.references :chatroom, foreign_key: true
      t.references :user, foreign_key: true
      t.string :body, null: false
      t.timestamps
    end
  end
end
