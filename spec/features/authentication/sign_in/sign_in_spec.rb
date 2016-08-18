require 'rails_helper'

feature 'Sign in' do
  context 'When activated' do
    let(:user) { create(:user, :activated) }

    scenario 'user cannot sign in if not registered', js: true do
      signin('person@example.com', 'password')
      expect_flash_with('Invalid email/password combination')
    end

    scenario 'user can sign in with valid credentials', js: true do
      signin(user.email, user.password)
      expect_flash_with('Welcome Back')
      expect(page).to have_css('#sign-out_link')
    end

    scenario 'user cannot sign in with wrong email', js: true do
      signin('invalid@email.com', user.password)
      expect_flash_with('Invalid email/password combination')
    end

    scenario 'user cannot sign in with wrong password', js: true do
      signin(user.email, 'invalidpass')
      expect_flash_with('Invalid email/password combination')
    end
  end

  context 'When not activated' do
    let(:user) { create(:user) }
    scenario 'user can not sign in with valid credentials', js: true do
      signin(user.email, user.password)
      expect_flash_with('Account waiting for activation.')
    end
  end
  context 'When signed in' do
    let(:user) { create(:user, :activated) }
    scenario 'user can sign out ' do
      signin(user.email, user.password)
      signout
      expect(page).to have_css('#sign-in_link')
    end
  end
end
