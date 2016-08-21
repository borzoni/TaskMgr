# frozen_string_literal: true
class Web::Profile::TasksController < Web::Profile::ApplicationController
  before_action :load_users

  def index
    @tasks = tasks_for_profile.filter(params).paginate(page: params[:page])
  end

  def load_users
    return unless current_user.admin?
    @users = User.order('email').all
  end
end
