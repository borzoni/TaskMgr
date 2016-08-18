class Web::RegistrationsController < Web::ApplicationController
  before_action :assert_not_auth

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_mail
      flash[:success] = 'Please check your email to activate your account.'
      redirect_to root_url
    else
      flash[:error] = "Sorry, can't sign up"
      render 'new'
    end
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
