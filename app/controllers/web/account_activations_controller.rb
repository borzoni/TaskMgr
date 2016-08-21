# frozen_string_literal: true
class Web::AccountActivationsController < Web::ApplicationController
  before_action :assert_not_auth

  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.activation_token_verify(secret_id: params[:id], secret: params[:secret])
      user.activate
      sign_in user
      flash[:success] = 'Account activated!'
      redirect_to profile_tasks_url
    else
      flash[:error] = 'Invalid activation link'
      redirect_to root_url
    end
  end
end
