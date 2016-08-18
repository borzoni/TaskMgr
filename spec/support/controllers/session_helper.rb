module Controllers
  module SessionHelper
    def signin(user = double('user'))
      return if user.nil?
      request.session[:uid] = user.id
      controller.current_user
    end
  end
end
