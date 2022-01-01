require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "ログイン関連" do
    let(:user) { create(:user) }
    it 'ログイン画面が表示される' do
      get '/login' 
      expect(response).to have_http_status(200)
    end

    it '会員登録済みならログインできる' do
      post '/login', params: { email: user.email, password: user.password }
      expect(response).to have_http_status(200)
    end

    it 'ログアウトできるか' do
      delete '/logout'
      expect(response).to have_http_status(302)
    end
  end 

  describe "会員登録" do
    it '会員登録ページを表示できる' do
      get new_user_path
      expect(response).to have_http_status(200)
    end
  end
  
end
