# frozen_string_literal: true
class Web::ApplicationController < ApplicationController
  include Pundit
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  use_growlyflash

  private

  def user_not_authorized
    flash[:error] = 'Access denied.'
    redirect_to(request.referrer || profile_tasks_path)
  end
end
