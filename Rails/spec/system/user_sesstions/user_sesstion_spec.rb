require 'rails_helper'
RSpec.describe 'ログイン・ログアウト', type: :system do

    let(:user) { create(:user) }

    describe 'ログイン' do
        context '認証情報が正しい場合' do
            it 'ログインができる' do
                visit '/login'
                fill_in'email', with: user.email
                fill_in'password', with: user.password
                sleep 2
                click_button'ログイン'
                sleep2
                expect(current_path).to eq(root_path)  
            end
        end   
        
        context "入力に誤りがある" do
            it 'ログインできない' do
                visit '/login'
                fill_in'email', with: user.email
                fill_in'password', with: '1234'
                sleep2
                click_button'ログイン'
                sleep
                expect(current_path).not_to eq(root_path) 
                expect(current_path).to eq(login_path)
                expect 
            end
        end
    end

    describe "ログアウトできる" do
        before do
            login
        end
        it 'ログアウトの確認' do
            click_button'ログアウト'
            expect(current_path).to eq login_path
            expect(response.body).to have_contain 'ログアウトpしました'
        end
    end
end
