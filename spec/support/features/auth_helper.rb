# frozen_string_literal: true
module Features
  module AuthHelpers
    def sign_up(email, password, confirmation)
      visit new_registration_path
      fill_user_backed_form(email, password, confirmation)
    end

    def fill_user_form(email, password, confirmation, path)
      visit send(path[:path], path[:param])
      fill_user_backed_form(email, password, confirmation)
    end

    def signin(email, password, remember_me = false)
      visit new_session_path
      fill_in 'session_email', with: email
      fill_in 'session_password', with: password
      page.check('session_remember_me') if remember_me
      find('input[name="commit"]').click
    end

    def signout
      click_link 'sign-out_link'
    end

    def password_reset_request(email)
      fill_in 'user_email', with: email
      find('input[name="commit"]').click
    end

    def enter_new_password(pwd, pwd_cnfrm)
      fill_in 'user_password', with: pwd
      fill_in 'user_password_confirmation', with: pwd_cnfrm
      find('input[name="commit"]').click
    end

    private

    def fill_user_backed_form(email, password, confirmation)
      fill_in 'user_email', with: email
      fill_in 'user_password', with: password
      fill_in 'user_password_confirmation', with: confirmation
      find('input[name="commit"]').click
    end
  end
end
