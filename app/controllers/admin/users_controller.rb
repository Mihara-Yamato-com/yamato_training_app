class Admin::UsersController < ApplicationController
before_action :require_admin

  def index
    @users = User.all
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    if demoting_last_admin?(@user)
      flash.now[:alert] = "最後の管理者の権限を変更することはできません"
      render :edit, status: :unprocessable_entity
    elsif @user.update(user_params)
      redirect_to admin_users_path, notice: "ユーザー情報の更新に成功しました"
    else
      flash.now[:alert] = "ユーザー情報の更新に失敗しました。"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user = User.find(params[:id])

    if @user == current_user
      redirect_to admin_users_path, alert: "自分自身のアカウントは削除できません"
    elsif @user.admin? && User.admin.count <= 1
      redirect_to admin_users_path, alert: "最後の管理者は削除できません"
    elsif @user.destroy
      redirect_to admin_users_path, notice: "ユーザーを削除しました"
    else
      redirect_to admin_users_path, alert: "削除できませんでした"
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :role)
  end

  def demoting_last_admin?(user)
    user.admin? && user_params[:role].to_s == "general" && User.admin.count <= 1
  end
end
