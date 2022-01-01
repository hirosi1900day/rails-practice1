require 'rails_helper'


RSpec.describe Post, type: :model do
  describe "バリデーション" do
    context "異常系" do
      it 'image必須' do
        post = build(:post, images: nil)
        post.valid?
        expect(post.errors[:images]).to include('を入力してください')
      end

      it 'body必須' do
        post = build(:post, body: nil)
        post.valid?
        expect(post.errors[:body]).to include('を入力してください')
      end
      
      it 'bodyが1000文字以上の時' do
        post = build(:post, body: 'a'*10000)
        post.valid?
        expect(post.errors[:body]).to include('は1000文字以内で入力してください')
      end

      it 'bodyが1000文字以下の場合' do
        post = build(:post, body: 'a'*12)
        post.valid?
        expect(post.save).to eq true
      end
    end
  end 
  describe "scope" do
    describe "body_contain" do
      let!(:post) { create(:post, body: 'hellow world') }
      subject { Post.body_contain('hello') } 
      it { is_expected.to include post }
    end
  end
end