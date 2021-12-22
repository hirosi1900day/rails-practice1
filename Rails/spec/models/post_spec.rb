require 'rails_helper'


RSpec.describe Post, type: :model do
  describe "バリデーション" do
    context "異常系" do
      it 'image必須' do
        post = build(:post, image: nil)
        post.valid?
        expect(post.errors[:image]).to include('入力してください')
      end

      it 'body必須' do
        post = build(:post, body: nil)
        post.valid?
        expect(post.errors[:body]).to include('入力してください')
      end
      
      it 'bodyが1000文字以上の時'
    end
  end 
end
