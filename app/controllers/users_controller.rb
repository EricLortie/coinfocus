# Renders the home page.
class UsersController < ApplicationController
  before_action :set_user, :only => %i[show edit update change_password] # probably want to keep using this

  before_action :verify_admin, :only => [:index]
  before_action :require_permission, :only => %i[show edit update change_password]

  def index
    @users = if params[:approved] == "false"
               User.where(:approved => false)
             else
               User.all.order("created_at DESC").paginate(:page => params[:page], :per_page => 30)
             end
  end

  def edit
  end

  def change_password
  end

  def update
  end

  def show
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  def require_permission
    return true unless current_user != @user.id and !current_user.admin?
    redirect_to root_path
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:role, :user_name, :time_zone)
  end
end
