require 'rails_helper'

describe Web::UsersController do
  context 'unauthenticated request' do
    let!(:user) { create(:user, :activated) }

    it '#index' do
      get :index
      expect(response).to redirect_to(new_session_path)
    end

    it '#show' do
      get :show, params: { id: user.id }
      expect(response).to redirect_to(new_session_path)
    end

    it '#new' do
      get :new
      expect(response).to redirect_to(new_session_path)
    end

    it '#create' do
      put :create, params: { id: user.id }
      expect(response).to redirect_to(new_session_path)
    end

    it '#edit' do
      get :edit, params: { id: user.id }
      expect(response).to redirect_to(new_session_path)
    end

    it '#update' do
      put :update, params: { id: user.id }
      expect(response).to redirect_to(new_session_path)
    end

    it '#destroy' do
      delete :destroy, params: { id: user.id }
      expect(response).to redirect_to(new_session_path)
    end
  end
  context 'unathorized access' do
    let!(:user) { create(:user, :activated) }
    let!(:admin) { create(:user, :activated, :admin) }
    before { signin(user) }

    it '#index' do
      get :index
      expect(flash[:error]).to be_eql('Access denied.')
    end

    it '#show' do
      get :show, params: { id: admin.id }
      expect(flash[:error]).to be_eql('Access denied.')
    end

    it '#new' do
      get :new
      expect(flash[:error]).to be_eql('Access denied.')
    end

    it '#create' do
      put :create, params: { user: { email: 'new@test.com' } }
      expect(flash[:error]).to be_eql('Access denied.')
    end

    it '#edit not self' do
      get :edit, params: { id: admin.id }
      expect(flash[:error]).to be_eql('Access denied.')
    end

    it '#edit self' do
      get :edit, params: { id: user.id }
      expect(subject).to render_template(:edit)
    end

    it '#update not self' do
      put :update, params: { id: admin.id, user: { email: 'new@test.com' } }
      expect(flash[:error]).to be_eql('Access denied.')
    end

    it '#update self' do
      put :update, params: { id: user.id, user: { email: 'new@test.com' } }
      expect(flash[:success]).to be_eql('Profile updated')
    end
  end

  context '#index' do
    let(:user) { create(:user, :activated, :admin) }
    let!(:list) { create_list(:user, 5) }
    before { signin(user) }

    it 'render view' do
      get :index
      expect(subject).to render_template(:index)
    end

    it 'filter' do
      get :index, params: { query: list.first.email }
      expect(assigns(:users)).to eq([list.first])
    end

    it 'pagination' do
      allow(User).to receive(:per_page).and_return(1)
      get :index
      expect(assigns(:users).length).to eq(1)
    end
  end

  context '#show' do
    let(:user) { create(:user, :activated, :admin) }
    before { signin(user) }

    it 'render view' do
      get :show, params: { id: user.id }
      expect(subject).to render_template(:show)
    end
  end

  context '#new' do
    let(:user) { create(:user, :activated, :admin) }
    before { signin(user) }

    it 'render view' do
      get :new
      expect(subject).to render_template(:new)
    end
  end

  context '#create' do
    let(:user) { create(:user, :activated, :admin) }
    before { signin(user) }

    it 'successfully created' do
      expect { post :create, params: { user: { email: 'te@mail.com', password: 'new_long', password_confirmation: 'new_long' } } }
        .to change { User.count }.from(1).to(2)
    end

    it 'cannot create provided validations errors' do
      post :create, params: { user: { email: 'testfailed@mail.com' } }
      expect(subject).to render_template(:new)
    end
  end

  context '#edit' do
    let!(:user) { create(:user, :activated) }
    before { signin(create(:user, :admin, :activated)) }

    it 'renders view' do
      get :edit, params: { id: user.id }
      expect(response).to render_template(:edit)
    end
  end

  context '#update' do
    let(:user) { create(:user, :activated) }
    before { signin(create(:user, :activated, :admin)) }

    it 'cannot update provided validations errors' do
      put :update, params: { id: user.id, user: { email: 'failed@mail.com', password: 'new' } }
      expect(subject).to render_template(:edit)
    end

    it 'successfully updated' do
      put :update, params: { id: user.id, user: { email: 'ok@mail.com' } }
      expect(user.reload.email).to be_eql('ok@mail.com')
    end
  end

  context '#destroy' do
    let!(:user) { create(:user, :activated, :admin) }
    before { signin(create(:user, :activated, :admin)) }

    it 'successfully destroyed' do
      expect { delete :destroy, params: { id: user.id } }.to change { User.count }.from(2).to(1)
    end
  end
end
