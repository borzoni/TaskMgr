require 'rails_helper'

describe Web::RegistrationsController do
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
  end

  context '#new' do
    it 'renders form' do
      get :new
      expect(subject).to render_template(:new)
    end
  end

  context '#create' do
    let(:user) { create(:user) }
    let(:user2) { create(:user, :activated) }

    it 'exisitng email' do
      post :create, params: { user: { email: user2.email, password: '12345678', password_confirmation: '12345678' } }
      expect(subject).to render_template(:new)
    end

    it 'wrong formatted email' do
      post :create, params: { user: { email: 'dfsdfd@56.67', password: '12345678', password_confirmation: '12345678' } }
      expect(subject).to render_template(:new)
    end

    it 'short password' do
      post :create, params: { user: { email: 'random@test.ru', password: '12', password_confirmation: '12' } }
      expect(subject).to render_template(:new)
    end
    it 'no password' do
      post :create, params: { user: { email: 'random@test.ru' } }
      expect(subject).to render_template(:new)
    end
    it 'different password' do
      post :create, params: { user: { email: 'random@test.ru', password: '12345678', password_confirmation: '1234577756' } }
      expect(subject).to render_template(:new)
    end
    it 'valid user' do
      post :create, params: { user: { email: 'random@test.ru', password: '12345678', password_confirmation: '12345678' } }
      expect(flash[:success]).to be_eql('Please check your email to activate your account.')
    end
  end
end
