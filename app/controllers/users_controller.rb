class UsersController < ApplicationController
  before_action :require_login

  def show
    @user = current_user
  end
    
  def new
    @user = User.new
  end

  def create
  end

  def edit
  end


end
