# frozen_string_literal: true
class Web::Tasks::ApplicationController < Web::ApplicationController
  before_action :assert_auth
  helper_method :resource_task

  private

  def resource_task
    @resource_task ||= Task.find(params[:task_id])
  end
end
