# frozen_string_literal: true
require 'rails_helper'

feature 'Sign up' do
  before(:each) { ActionMailer::Base.deliveries = [] }
  scenario 'user can sign up with valid credentials', js: true do
    sign_up('tested@mail.ru', 'qwerty12345', 'qwerty12345')
    expect_flash_with('Please check your email to activate your account.')
    expect(ActionMailer::Base.deliveries.count).to eq(1)
  end
  scenario 'user can not sign up with wrong email' do
    sign_up('test@mail.56', 'qwerty12345', 'qwerty12345')
    expect(page).to have_css('form.new_user .form-group.has-error #user_email', visible: true, count: 1)
    expect(ActionMailer::Base.deliveries.count).to eq(0)
  end
  scenario 'user can not sign up with short password' do
    sign_up('test@mail.ru', 'qwe', 'qwe')
    expect(page).to have_css('form.new_user .form-group.has-error #user_password', visible: true, count: 1)
    expect(ActionMailer::Base.deliveries.count).to eq(0)
  end
  scenario 'user can not sign up with empty password' do # just in case, coz has_secure_password is tricky
    sign_up('test@mail.ru', '', '')
    expect(page).to have_css('form.new_user .form-group.has-error #user_password', visible: true, count: 1)
    expect(ActionMailer::Base.deliveries.count).to eq(0)
  end
  scenario 'user can not sign up with unmatching password confirmation' do
    sign_up('test@mail.ru', 'qwerty12345', 'qwerty12346')
    expect(page).to have_css('form.new_user .form-group.has-error #user_password_confirmation', visible: true, count: 1)
    expect(ActionMailer::Base.deliveries.count).to eq(0)
  end

  context 'When user already exists' do
    let(:user) { create(:user) }
    scenario 'user can not sign up with already taken email' do
      sign_up(user.email, 'qwerty12345', 'qwerty12345')
      expect(page).to have_css('form.new_user .form-group.has-error #user_email', visible: true, count: 1)
      expect(ActionMailer::Base.deliveries.count).to eq(0)
    end
  end
end
