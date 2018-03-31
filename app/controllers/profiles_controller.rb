class ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:edit, :update, :destroy]

  def edit
    respond_to do |format|
      format.html { redirect_to admin_path }
      format.js
    end
  end

  def update

    if @user.update(user_params)
      @users = User.order('role,username')
      flash[:info] = t('devise.registrations.update_user')
    else
      @errors_found = true
    end
    respond_to do |format|
      format.html { redirect_to admin_path }
      format.js
    end
  end

  def destroy

    @user.destroy
    @users = User.order('role,username')
    respond_to do |format|
      format.html { redirect_to admin_path }
      format.js
    end
  end

  def create
    if params[:user]
      user = User.new_with_password(user_params)

      unless user.save
        @error_message = user.errors.full_messages.map { |msg| msg }.join('<br />') if user.errors
        @error_message ||= t(:cannot_save_new_user, scope: 'devise.errors.messages')
      end
    else
      @error_message ||= t(:cannot_save_new_user, scope: 'devise.errors.messages')
    end
    @users = User.order('role,username')
    respond_to do |format|
      format.html { redirect_to admin_path }
      format.js { render layout: false }
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:username, :email, :role)
  end

end
