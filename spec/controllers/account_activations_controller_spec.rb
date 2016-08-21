# frozen_string_literal: true
require 'rails_helper'

describe Web::AccountActivationsController do
  context 'already authenticated' do
    let!(:user) { create(:user, :activated) }
    before { signin(user) }

    it '#edit' do
      get :edit, params: { id: user.id }
      expect(response.status).to eql(302)
      expect(flash[:notice]).to be_eql('You\'ve already signed')
    end
  end
  context 'activation' do
    let!(:user) { create(:user) }

    it 'access with wrong token' do
      put :edit, params: { email: user.email, id: '12313', secret: 'WrOnG' }
      expect(flash[:error]).to be_eql('Invalid activation link')
    end

    it 'edits with valid input' do
      put :edit, params: { email: user.email, id: user.activation_token.secret_id, secret: user.activation_token.secret }
      expect(flash[:success]).to be_eql('Account activated!')
    end
  end
end
