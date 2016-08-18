require 'rails_helper'

describe Web::Profile::TasksController do
  context 'unauthenticated' do
    it '#index' do
      get :index
      expect(response).to redirect_to(new_session_path)
    end
  end

  context 'index page interactions' do
    let!(:user) { create(:user, :activated, :admin) }
    let!(:tasks) { create_list(:task, 5) }
    before { signin(user) }

    it 'assign tasks' do
      get :index
      expect(assigns(:tasks).length).to be_eql(5)
    end

    it 'assign users for filter' do
      get :index
      expect(assigns(:users).length).to be_eql(6)
    end

    it 'render view' do
      get :index
      expect(subject).to render_template(:index)
    end

    it 'filter' do
      get :index, params: { assignee_id: user.id }
      expect(assigns(:tasks)).to be_blank
    end

    it 'filter2' do
      create(:task, user: user)
      get :index, params: { assignee_id: user.id }
      expect(assigns(:tasks).length).to be_eql(1)
    end

    it 'pagination' do
      allow(Task).to receive(:per_page).and_return(1)
      get :index
      expect(assigns(:tasks).length).to eq(1)
    end
  end
end
