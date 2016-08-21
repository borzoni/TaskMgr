# frozen_string_literal: true
module SessionsHelper
  def sign_in(user)
    session[:uid] = user.id
  end

  def remember(user)
    token = user.generate_remember_token
    cookies.permanent.signed[:rtoken_id] = token.secret_id
    cookies.permanent.signed[:rtoken_secret] = token.secret
  end

  def current_user?(user)
    user == current_user
  end

  def current_user
    if (user_id = session[:uid])
      @current_user ||= User.find_by(id: user_id)
    else
      remember_token_process
    end
  end

  def signed_in?
    !current_user.nil?
  end

  def forget(user)
    user.remember_token_clear
    cookies.delete(:rtoken_id)
    cookies.delete(:rtoken_secret)
  end

  def sign_out
    forget(current_user)
    session.delete(:uid)
    @current_user = nil
  end

  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  def store_location
    session[:forwarding_url] = request.url if request.get?
  end

  def assert_auth
    unless signed_in?
      store_location
      flash[:error] = 'Please sign in.'
      redirect_to new_session_path
    end
  end

  def assert_not_auth
    if signed_in?
      flash[:notice] = 'You\'ve already signed'
      redirect_to profile_tasks_url
    end
  end

  private

  def remember_token_process
    rtoken_id = cookies.signed[:rtoken_id]
    secret = cookies.signed[:rtoken_secret]
    return nil if !secret || !rtoken_id
    token = AuthToken.find_authenticated(secret: secret, secret_id: rtoken_id)
    user = token&.authenticatable
    return unless user
    (forget(user) && return) if user.remember_token_expired?
    sign_in(user)
    @current_user = user
  end
end
