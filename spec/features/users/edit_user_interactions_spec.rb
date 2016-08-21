# frozen_string_literal: true
require 'rails_helper'

feature 'User edits user' do
  context 'When admin' do
    let(:user) { create(:user, :admin, :activated) }
    before { signin(user.email, user.password) }
    it_should_behave_like 'user_form_common_checks' do
      let(:path) { { path: :edit_user_path, param: user.id } }
    end
  end

  context 'When user' do
    let(:user) { create(:user, :activated) }
    before { signin(user.email, user.password) }
    context 'Own profile' do
      it_should_behave_like 'user_form_common_checks' do
        let(:path) { { path: :edit_user_path, param: user.id } }
      end
    end

    context "Other\'s profile" do
      let(:other) { create(:user, :activated) }
      scenario 'user should not be allowed to access', js: true do
        visit edit_user_path(other)
        expect_flash_with('Access denied.')
      end
    end
  end
end
