class Web::Profile::ApplicationController < Web::ApplicationController

  before_action :assert_auth
  helper_method :profile_user

  private

  def profile_user
    @profile_user ||= User.find(current_user.id)
  end

  def tasks_for_profile
    @tasks ||= if current_user&.admin?
                 Task.preload(:user)
               else
                 profile_user.tasks.preload(:user)
               end
  end

end
