class Admin::UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show
  end


  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to admin_users_path, notice: "ユーザー情報の更新に成功しました"
    else
      flash.now[:alert] = 'ユーザー情報の更新に失敗しました。'
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :role)
  end
end
