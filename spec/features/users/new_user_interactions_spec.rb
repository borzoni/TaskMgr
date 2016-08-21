# frozen_string_literal: true
require 'rails_helper'

feature 'User creates new user' do
  context 'When admin' do
    before do
      user = create(:user, :admin, :activated)
      signin(user.email, user.password)
    end

    it_should_behave_like 'user_form_common_checks' do
      let(:path) { { path: :new_user_path, param: nil } }
      scenario 'user can not pass through with empty password' do
        fill_user_form('test@mail.ru', '', '', path)
        expect(page).to have_css('.form-group.has-error #user_password', visible: true, count: 1)
      end
      scenario 'user can not pass through with unmatching password confirmation' do
        fill_user_form('test@mail.ru', 'qwerty12345', 'qwerty12346', path)
        expect(page).to have_css('.form-group.has-error #user_password_confirmation', visible: true, count: 1)
      end
    end

    context 'When email exists' do
      let(:other_user) { create(:user, :activated) }
      scenario 'user can not create user with already taken email' do
        fill_user_form(other_user.email, 'qwerty12345', 'qwerty12345', path: :new_user_path, param: nil)
        expect(page).to have_css('.form-group.has-error #user_email', visible: true, count: 1)
      end
    end
  end

  context 'When user' do
    let(:user) { create(:user, :activated) }
    before { signin(user.email, user.password) }
    scenario 'user should not be allowed to access', js: true do
      visit new_user_path
      expect_flash_with('Access denied.')
    end
  end
end
