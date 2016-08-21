# frozen_string_literal: true
require 'rails_helper'

feature 'Password Reset' do
  let(:user) { create(:user, :activated) }
  before(:each) { ActionMailer::Base.deliveries = [] }
  context 'When enters email where to send reset instructions' do
    before(:each) { visit new_password_reset_path }
    scenario 'user can request password recovery given valid email', js: true do
      password_reset_request(user.email)
      expect_flash_with('Email sent with password reset instructions')
      expect(ActionMailer::Base.deliveries.count).to eq(1)
    end
    scenario 'user can not request password recovery given invalid email', js: true do
      password_reset_request('invalid@mail.com')
      expect_flash_with('Email address not found!')
      expect(page).to have_css('.form-group.has-error #user_email', visible: true, count: 1)
      expect(ActionMailer::Base.deliveries.count).to eq(0)
    end
  end
  context 'When follows link from email ' do
    before(:each) do
      visit new_password_reset_path
      password_reset_request(user.email)
      open_email(user.email)
    end
    scenario 'user can follow valid link from email and see a form' do
      current_email.click_link 'reset_link'
      expect(page).to have_content('Enter a new password')
    end
    scenario 'user can not follow invalid link from email', js: true do
      visit edit_password_reset_path(id: 'random', secret: 'randon', email: 'invalid@mail.ru')
      expect_flash_with('Password reset can\'t be applied for you.')
    end
  end
  context 'When enters new password' do
    before(:each) do
      visit new_password_reset_path
      password_reset_request(user.email)
      open_email(user.email)
      current_email.click_link 'reset_link'
    end
    scenario 'user can change for a valid password', js: true do
      enter_new_password('password', 'password')
      expect_flash_with('Password has been reset.')
    end
    scenario 'user can not change for short password' do
      enter_new_password('pass', 'pass')
      expect(page).to have_css('.form-group.has-error #user_password', visible: true, count: 1)
    end
    scenario 'user can not change for empty password' do
      enter_new_password('', '')
      expect(page).to have_css('.form-group.has-error #user_password', visible: true, count: 1)
    end
    scenario 'user can not change for a password with unmatching password confirmation' do
      enter_new_password('password', 'password1')
      expect(page).to have_css('.form-group.has-error #user_password_confirmation', visible: true, count: 1)
    end
    scenario 'user can not change for a password with no password confirmation' do
      enter_new_password('password', '')
      expect(page).to have_css('.form-group.has-error #user_password_confirmation', visible: true, count: 1)
    end
  end
  context 'When reset link expired' do
    before(:each) do
      visit new_password_reset_path
      password_reset_request(user.email)
      open_email(user.email)
      expect_any_instance_of(AuthToken).to receive(:created_at).and_return(Time.now - 3.days)
      current_email.click_link 'reset_link'
    end
    scenario 'user can not change with expired token', js: true do
      expect_flash_with('Password reset has expired.')
    end
  end
end
