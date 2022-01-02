class UserSessionsController < ApplicationController
  def new
  end

  def create
    @user = login(params[:email], params[:password])
    
    if @user
      cookies.signed["user.id"] = current_user.id
      redirect_back_or_to(root_path, notice: 'ログインに成功しました')
    else
      flash.now[:alert] = 'ログインに失敗しました'
      render :new
    end
  end

  def destroy
    logout
    cookies.delete("user.id")
    redirect_to(login_path, notice: 'ログアウトしました')
  end
end
