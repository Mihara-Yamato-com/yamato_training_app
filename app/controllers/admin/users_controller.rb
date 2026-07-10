class Admin::UsersController < ApplicationController
def index
  unless current_user.admin?
    redirect_to user_path, alert: "権限が足りません"
    return
  end

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
      redirect_to admin_user_path, notice: "ユーザー情報の更新に成功しました"
    else
      flash.now[:alert] = 'ユーザー情報の更新に失敗しました。'
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user = User.find(params[:id])

    if @user.destroy
      redirect_to admin_users_path, notice: "ユーザーを削除しました"
    else
      redirect_to admin_users_path, alert: "削除できませんでした"
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :role)
  end
end
