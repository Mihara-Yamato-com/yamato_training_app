class SessionsController < ApplicationController
before_action :require_login, only: [:destroy]

  def new
  end

  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      reset_session
      session[:user_id] = user.id
        if user.general?
          redirect_to user_path, notice: "ログインに成功しました"
        elsif user.admin?
          redirect_to admin_users_path, notice: "管理者としてログインに成功しました"
        end
    else
      flash.now[:alert] = "メールアドレスまたはパスワードが正しくありません。"
      render :new, status: :unprocessable_entity # ブラウザに失敗したことを伝えるため
    end
  end

  def destroy
    reset_session
    redirect_to login_path, notice: "ログアウトしました"
  end
end
