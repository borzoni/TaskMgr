require 'rails_helper'

describe Web::PasswordResetsController do
  context 'already authenticated' do
    let!(:user) { create(:user, :activated) }
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

    it '#edit' do
      get :edit, params: { id: user.id }
      expect(response.status).to eql(302)
      expect(flash[:notice]).to be_eql('You\'ve already signed')
    end

    it '#update' do
      put :update, params: { id: user.id }
      expect(response.status).to eql(302)
      expect(flash[:notice]).to be_eql('You\'ve already signed')
    end
  end

  context '#new' do
    it 'renders form' do
      get :new
      expect(subject).to render_template(:new)
    end
  end

  context '#create' do
    let(:user) { create(:user, :activated) }

    it 'wrong email' do
      post :create, params: { user: { email: 'badinput@user.de' } }
      expect(subject).to render_template(:new)
    end

    it 'can send instructions' do
      post :create, params: { user: { email: user.email } }
      expect(flash[:notice]).to be_eql('Email sent with password reset instructions')
    end
  end

  context '#edit' do
    let!(:user) { create(:user, :activated) }

    it 'without token' do
      get :edit, params: { id: user.id }
      expect(flash[:error]).to be_eql('Password reset can\'t be applied for you.')
    end

    it 'render form' do
      user.generate_forgot_token
      get :edit, params: { email: user.email, id: user.forgot_token.secret_id, secret: user.forgot_token.secret }
      expect(subject).to render_template(:edit)
    end
  end

  context '#update' do
    let!(:user) { create(:user, :activated) }

    it 'access with wrong token' do
      put :update, params: { email: user.email, id: '12313', secret: 'WrOnG' }
      expect(flash[:error]).to be_eql('Password reset can\'t be applied for you.')
    end

    it 'cannot edit - no password confirmation' do
      user.generate_forgot_token
      id = user.forgot_token.secret_id
      secret = user.forgot_token.secret
      put :update, params: { email: user.email, id: id, secret: secret, user: { password: 'new passsowoordo' } }
      expect(subject).to render_template(:edit)
    end

    it 'cannot edit  - wrong password confirmation' do
      user.generate_forgot_token
      id = user.forgot_token.secret_id
      secret = user.forgot_token.secret
      put :update, params: { email: user.email, id: id, secret: secret, user: { password: '12345690', password_confirmation:  '12056676443' } }
      expect(subject).to render_template(:edit)
    end

    it 'edits with valid input' do
      user.generate_forgot_token
      id = user.forgot_token.secret_id
      secret = user.forgot_token.secret
      put :update, params: { email: user.email, id: id, secret: secret, user: { password: 'newpasswd', password_confirmation:  'newpasswd' } }
      expect(flash[:success]).to be_eql('Password has been reset.')
    end
  end
end
