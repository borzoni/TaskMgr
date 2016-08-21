# frozen_string_literal: true
require 'rails_helper'

describe Web::SessionsController do
  context '#new' do
    it 'render form' do
      get :new
      expect(response.status).to eql(200)
    end
  end

  context 'already authorized' do
    let!(:user) { create(:user) }
    before { signin(user) }

    it '#new' do
      get :new
      expect(response.status).to eql(302)
      expect(flash[:notice]).to be_eql('You\'ve already signed')
    end

    it '#create' do
      post :create
      expect(response.status).to eql(302)
      expect(flash[:notice]).to be_eql('You\'ve already signed')
    end
  end

  context 'destroy' do
    let(:user) { create(:user, :activated) }
    it 'already signed out' do
      get :destroy, params: { id: user.id }
      expect(response.status).to eql(302)
    end

    it 'success' do
      signin(user)
      get :destroy, params: { id: user.id }
      expect(session[:uid]).to be_nil
    end
  end

  context '#create' do
    let!(:user) { create(:user, :activated) }

    it 'cannot authenticate - wrong email' do
      post :create, params: { session: { email: 'invalid@test.com' } }
      expect(flash[:error]).to be_eql('Invalid email/password combination')
    end

    it 'cannot authenticate - wrong password' do
      post :create, params: { session: { email: user.email, password: 'invalid_pass' } }
      expect(flash[:error]).to be_eql('Invalid email/password combination')
    end

    it 'can authenticate if valid' do
      post :create, params: { session: { email: user.email, password: user.password } }
      expect(controller.current_user).to be_eql(user)
    end
    it 'remembers user if specified' do
      expect(cookies[:rtoken_id]).to be_nil
      expect(cookies[:rtoken_secret]).to be_nil
      post :create, params: { session: { email: user.email, password: user.password, remember_me: 1 } }
      expect(cookies[:rtoken_id]).to be_present
      expect(cookies[:rtoken_secret]).to be_present
    end

    it 'does not remember user if specifified' do
      expect(cookies[:rtoken_id]).to be_nil
      expect(cookies[:rtoken_secret]).to be_nil
      post :create, params: { session: { email: user.email, password: user.password } }
      expect(cookies[:rtoken_id]).to be_nil
      expect(cookies[:rtoken_secret]).to be_nil
    end

    it 'saves currently signed user in current_user' do
      post :create, params: { session: { email: user.email, password: user.password, remember_me: 1 } }
      expect(controller.current_user).to be_eql(user)
    end

    it 'returns correct signed_in flag accordingly to the currently signed user' do
      expect(controller.signed_in?).to be_falsey
      post :create, params: { session: { email: user.email, password: user.password, remember_me: 1 } }
      expect(controller.signed_in?).to be_truthy
    end

    it 'returns correct predicate current_user?(user) accordingly to the currently signed user' do
      expect(controller.current_user?(user)).to be_falsey
      post :create, params: { session: { email: user.email, password: user.password, remember_me: 1 } }
      expect(controller.current_user?(user)).to be_truthy
    end
  end

  context 'remember me authentication' do
    let!(:user) { create(:user, :activated) }

    it 'successfully signs from remember_token' do
      post :create, params: { session: { email: user.email, password: user.password, remember_me: 1 } }
      session[:uid] = nil
      expect(controller.signed_in?).to be_truthy
    end

    it 'fails to sign if remember_token empty' do
      post :create, params: { session: { email: user.email, password: user.password, remember_me: 1 } }
      session[:uid] = nil
      cookies[:rtoken_secret].clear
      cookies[:rtoken_id].clear
      expect(controller.signed_in?).to be_falsey
    end

    it 'fails to sign in provided token expired' do
      post :create, params: { session: { email: user.email, password: user.password, remember_me: 1 } }
      expect_any_instance_of(AuthToken).to receive(:created_at).and_return(Time.now - 30.days)
      session[:uid] = nil
      expect(controller.signed_in?).to be_falsey
    end
  end
end
