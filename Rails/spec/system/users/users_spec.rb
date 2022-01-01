require 'rails_helper'
RSpec.describe '登録', type: :system do
    describe "ユーザー登録" do
        it '登録成功' do
            visit new_user_path
            fill_in 'name', with: 'test'
            fill_in 'email', with: 'rails@example.com'
            fill_in 'password', with: '12345678'
            fill_in 'password_confirmation', with: '12345678'
            click_button '登録'
            expect(current_path).to eq login_path
            expect(page).to have_content 'ユーザーの作成に成功しました'
        end
        it '登録失敗' do
            visit new_user_path
            fill_in 'name', with: ''
            fill_in 'email', with: ''
            fill_in 'password', with: ''
            fill_in 'password_confirmation', with: '12345678'
            click_button '登録'
            expect(page).to have_content 'ユーザー名を入力してください'
            expect(page).to have_content 'メールアドレスを入力してください'
            expect(page).to have_content 'パスワードは3文字以上で入力してください'
            expect(page).to have_content 'パスワード確認を入力してください'
            expect(page).to have_content 'ユーザーの作成に失敗しました'
        end
    end

    describe "フォロー関係" do
        let(:user1) { create(:user) }
        let(:user2) { create(:user) }

        before do
            login_as user1
        end

        it 'フォローができること' do
            visit users_path
            expect {
                within "#follow-area-#{user2.id}" do
                    click_link 'フォローする'
                    expect(page).to have_content 'フォローを解除する'
                end
            }.to change { user1.following.count }.by(1)
        end

        it 'フォローが解除できること'  do
            visit users_path
            expect {
                within "#follow-area-#{user2.id}" do
                    click_link 'フォローを解除する'
                    expect(page).to have_content 'フォローする'
                end
            }.to change { login.following }.by(-1)
        end
    end
end