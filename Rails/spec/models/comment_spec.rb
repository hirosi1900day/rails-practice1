# == Schema Information
#
# Table name: comments
#
#  id         :bigint           not null, primary key
#  body       :text(65535)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  post_id    :bigint
#  user_id    :bigint
#
# Indexes
#
#  index_comments_on_post_id  (post_id)
#  index_comments_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (post_id => posts.id)
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe "バリデーションチェック" do
    it 'bodyが1000文字より大きい場合validationエラーが発生する'  do
        comment = build(:comment, body: 'a'*1001)
        comment.valid?
        expect(comment.errors[:body]).to include('は1000文字以内で入力してください')
    end
  end
end
 
