class AdminsController < ApplicationController
  before_action :authenticate_user!, :admin_user

  def all_users
    @users = User.paginate(page: params[:page], per_page: 20)
  end


  private
    def admin_user
      redirect_to root_url unless admin?
    end
end
