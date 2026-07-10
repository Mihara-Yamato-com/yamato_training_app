class SessionsController < ApplicationController
  def new
  end

  def create
    email = params[:email].to_s.downcase
    password = params[:password]

    user = User.find_by(email: email)
    if user && user.authenticate(password)
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
