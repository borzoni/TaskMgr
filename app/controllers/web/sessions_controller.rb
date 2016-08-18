class Web::SessionsController < Web::ApplicationController
  before_action :assert_not_auth, except: :destroy
  before_action :assert_auth, only: :destroy

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email])
    if user && user.authenticate(params[:session][:password])
      if user.activated?
        sign_in user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        flash[:success] = 'Welcome Back'
        redirect_back_or profile_tasks_url
      else
        message  = 'Account waiting for activation. '
        message += 'Check your email for the activation link.'
        flash[:warning] = message
        redirect_to root_url
      end
    else
      flash[:error] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    sign_out if signed_in?
    redirect_to root_url
  end
end
