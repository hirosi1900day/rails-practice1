require 'rails_helper'

RSpec.describe User, type: :model do
    describe "バリデーション 異常系" do
        it 'nameが必須である' do
            user = build(:user, name: nil)
            user.valid?
            except(user.errors[:name]).to include('を入力してください')
        end

        it 'メールアドレスが必須である' do
            user = build(:user, email: nil)
            user.valid?
            except(user.errors[:email]).to include('を入力してください')
        end

        it '登録できないこと' do
            user = User.new
            expect(user.save).to be_falsey
        end

        it 'メールアドレスの一意性' do
            user = create(:user)
            other_user = build(:user, email: user.email)
            other_user.valid? 
            expect(other_user.errors[:email]).to include('すでに存在しています')  
        end

        it 'ユーザー名の一意性' do
            user = create(:user)
            other_user = create(:user, name: user.name)
            other_user.valid?
            expect(other_user.errors[:name]).to include('すでに存在しています')  
        end  
    end

    describe "インスタンスメソッド" do
        let(:user_a) { create(:user) }
        let(:user_b) { create(:user) }
        let(:user_c) { create(:user) }
        let(:post_by_user_a) { create(:post, user:user_a) }
        let(:post_by_user_b) { create(:post, user: user_b) }
        let(:post_by_user_c) { create(:post, user: user_c) }

        context "オブジェクト確認" do
            it '自分のオブジェクトの場合' do
                expect(user_a.own?(post_by_user_a)).to eq true
            end
    
            it '自分のいんオブジェクトではない場合' do
                expect(user_a.own?(post_by_user_b)).to eq false  
            end
        end

        context "likeの確認" do
            it 'likeできること' do
                expect(user_a.like(post_by_user_b)).to change { Like.count }.by(1)
            end 

            it 'likeが解除できること' do
                user_a.like(post_by_user_b)
                expect(user_a.unlike(post_by_user_b)).to change { Like.count }.by(-1)
            end

            it 'お気に入りしているか確認できる お気に入りしている場合' do
                user_a.like(post_by_user_b)
                expect(user_a.like?(post_by_user_b)).to eq true 
            end

            it 'お気に入りしていない場合' do
                expect(user_a.like?(post_by_user_c)).to eq false 
            end
        end

        context "フォロメソッド" do
            it 'フォローができること' do
                expect(user_a.follow(user_b)).to change { Relationship.count }.by(1)     
            end

            it 'フォローが解除できること' do
                user_a.follow(user_c)
                expect(user_a.unfollow(user_c)).to change { Relationship.count }.by(-1)
            end

            it 'フォローしている場合 true' do
                user_a.follow(user_b)
                expect(user_a.following?(user_b)).to eq true
            end

            it 'フォローしていない場合 false' do
                expect(user_a.following?(user_c)).to eq false
            end
        end   
        
        context "feedでフォロー中のuserと自分の投稿を表示する" do
            it 'user_aとuser_bのpostが表示される' do
                user_a.follow(user_b)

            end
        end

        describe 'feedの確認' do
            before do
                user_a.follow(user_b)
            end
            subject { user_a.feed }
            it { is_expected.to include post_by_user_a }
            it { is_expected.to include post_by_user_b }
            it { is_expected.not_to include post_by_user_c }
        end
    end
end
