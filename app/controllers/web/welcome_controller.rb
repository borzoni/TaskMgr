# frozen_string_literal: true
class Web::WelcomeController < Web::ApplicationController
  before_action :assert_not_auth
  def index
    @tasks = Task.preload(:user).order(id: :desc).paginate(page: params[:page])
  end
end
