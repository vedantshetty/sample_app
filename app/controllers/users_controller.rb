class UsersController < ApplicationController
  def new
    @user = User.new
    @blohh = Time.now
  end

  def create
    @user = User.new(whitelisted_user_params)
    if @user.save
      log_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      puts @user.errors.messages
      @blohh = Time.now
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
  end

  private

    def whitelisted_user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

end
