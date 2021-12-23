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
 