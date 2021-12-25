module SystemHelper
    def login
        user = create(:user)
        visit login_path
        fill_in'email', with: user.email
        fill_in'passsword', with: user.password
        click_button'ログイン'
    end
    
    def login_as(user)
        visit login_path
        fill_in'email', with: user.email
        fill_in'password', with: user.password
        click_button'ログイン'
    end
end