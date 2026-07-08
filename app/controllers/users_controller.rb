class UsersController < ApplicationController
  before_action :require_login

  def show
    @user = current_user
  end

  def edit
  end

  def new
  end
end
