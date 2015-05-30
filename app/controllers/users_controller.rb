class UsersController < ApplicationController
  before_action :authenticate_user!, :set_user
  before_action :correct_user, only: :destroy

  def show
  end

  def destroy
    @user.destroy
    if admin?
      flash[:notice] = 'User deleted'
    else
      flash[:notice] = 'Bye! Your account has been successfully cancelled. We hope to see you again soon.'
    end
    redirect_to root_url
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def correct_user
      unless current_user == @user || admin?
        redirect_to root_url
      end
    end
end
