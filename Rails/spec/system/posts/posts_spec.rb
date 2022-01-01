require 'rails_helper'

RSpec.describe 'ポスト', type: :system do
    describe "投稿一覧に関して" do
        let(:login_user) { create(:user) }
        let(:follow_user) { create(:user) }
        let(:other_user) { create(:user) }
        let(:post) { create(:post) }
        let(:login_user_post) { create(:post, user: login_user) }
        let(:follow_user_post) { create(:post, user: follow_user) }
        let(:other_user_post) { create(:post, user: other_user) }

        context "ログインしている時" do 
            before do
                login_as login_user
                login_user.follow(follow_user)
            end

            it 'フォローしているユーザーと自分の投稿のみ表示される' do
                visit posts_path 
                expect(page).to have_content login_user_post.body
                expect(page).to have_content follow_user_post.body
                expect(page).to_not have_content other_user_post.body
            end

        end
        context "ログインしていない時" do
            it '全ての投稿が表示される' do
            visit posts_path 
                expect(page).to have_content login_user_post.body
                expect(page).to have_content follow_user_post.body
                expect(page).to have_content other_user_post.body
            end
        end  
    end

    describe 'ポスト投稿' do
        it '画像を投稿できること' do
          login
          visit new_post_path
          within '#posts_form' do
            attach_file '画像', Rails.root.join('spec', 'fixtures', 'fixture.png')
            fill_in '本文', with: 'This is an example post'
            click_button '登録する'
          end
          expect(page).to have_content '投稿しました'
          expect(page).to have_content 'This is an example post'
        end
    end


    describe '後進できる' do
        let(:login_user) { create(:user) }
        let(:login_user_post) { create(:post, user: login_user)}
        let(:other_user_post) { create(:post) }
        before do
            login_as login_user 
        end 
        it '自分の投稿に削除ボタンが表示される' do
            visit posts_path
            within "#post-#{login_user_post.id}" do
                expect(page).to have_css '.delete-button'
                expect(page).to have_css '.edit-button'
            end
        end

        it '他人の投稿には削除ボタンが表示されない' do
            visit posts_path
            within "#post-#{other_user_post.id}" do
                expect(page).to_not have_css '.delete-button'
                expect(page).to_not have_css '.edit-button'
            end
        end

        it '投稿が編集できる' do
            visit edit_posts_path
            within "#post_form" do
                attach_file '画像', Rails.root.join('spec', 'fixtures', 'fixture.png')
                fill_in '本文', with: 'This is an example updated post'
                click_button '更新する'
            end
            expect(page).to have_content '投稿を更新しました'
            expect(page).to have_content 'This is an example updated post'
        end
    end

    describe "投稿削除" do
        let(:login_user) { create(:user) }
        let(:login_user_post) { create(:post, user: login_user)}
        let(:other_user_post) { create(:post) }
        before do
            login_as login_user
        end
        it '投稿が削除できること' do
            visit posts_path
            within "#post-#{login_user_post.id}" do
                page.accept_confirm{ find('.delete-button').click }
            end
            expect(page).to have_content '投稿を削除しました'
            expect(page).not_to have_content post_by_user.body
        end
    end
    
    describe "ポスト詳細" do
        let(:user) { create(:user) }
        let(:post_by_user) { create(:post, user: user) }

        before do
            login_as user
        end
        it '投稿の詳細画面が閲覧できる' do
            visit post_path(post_by_user)
            expect(current_path).to eq post_path(post_by_user)
        end
    end

    describe 'いいね' do
        let!(:user) { create(:user) }
        let!(:post) { create(:post) }
        before do
          login_as user
          user.follow(post.user)
        end
        it 'いいねができること' do
          visit posts_path
          expect {
            within "#post-#{post.id}" do
              find('.like-button').click
              expect(page).to have_css '.unlike-button'
            end
          }.to change(user.like_posts, :count).by(1)
        end
    
        it 'いいねを取り消せること' do
            user.like(post)
            visit posts_path
            expect {
                within "#post-#{post.id}" do
                  find('.unlike-button').click
                  expect(page).to have_css '.like-button'
                end
            }.to change(user.like_posts, :count).by(-1)
        end
    end   
end
