class ApplicationController < ActionController::Base
  helper_method :current_user
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  def current_user
    @current_user ||=User.find_by(id: session[:user_id])
  end

  def require_login
    redirect_to login_path, alert: "ログインしてください" unless current_user
  end

  def require_admin
    unless current_user&.admin?
      redirect_to user_path, alert: "管理者のみアクセスできます。"
    end
  end
end


