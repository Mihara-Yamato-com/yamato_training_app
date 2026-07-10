class UsersController < ApplicationController
  before_action :require_login, except: [ :new, :create ]

  def show
    @user = current_user
  end

  def new
    @user = User.new # new.html.erbで値を入れるためのインスタンス作成
  end

  def create
    name = params[:name]
    email = params[:email].to_s.downcase
    password = params[:password]
    @user = User.new(name: name, email: email, password: password, role: :general)
      if @user.save
        session[:user_id] = @user.id
        redirect_to user_path, notice: "ユーザー登録に成功しました"
      else
        flash.now[:alert] = "新規登録に失敗しました。"
        render :new, status: :unprocessable_entity
      end
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(user_params)
      redirect_to user_path, notice: "ユーザー情報の更新に成功しました"
    else
      flash.now[:alert] = "ユーザー情報の更新に失敗しました。"
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email)
  end
end
