require 'rails_helper'

describe Web::TasksController do
  context 'unauthenticated request' do
    let!(:task) { create(:task) }

    it '#show' do
      get :show, params: { id: task.id }
      expect(response).to redirect_to(new_session_path)
    end

    it '#new' do
      get :new
      expect(response).to redirect_to(new_session_path)
    end

    it '#create' do
      put :create, params: { id: task.id }
      expect(response).to redirect_to(new_session_path)
    end

    it '#edit' do
      get :edit, params: { id: task.id }
      expect(response).to redirect_to(new_session_path)
    end

    it '#update' do
      put :update, params: { id: task.id }
      expect(response).to redirect_to(new_session_path)
    end

    it '#destroy' do
      delete :destroy, params: { id: task.id }
      expect(response).to redirect_to(new_session_path)
    end

    it '#start' do
      put :start, params: { id: task.id }
      expect(response).to redirect_to(new_session_path)
    end

    it '#finish' do
      put :finish, params: { id: task.id }
      expect(response).to redirect_to(new_session_path)
    end

    it '#reopen' do
      put :reopen, params: { id: task.id }
      expect(response).to redirect_to(new_session_path)
    end
  end

  context 'unauthorizeds' do
    let!(:user) { create(:user, :activated) }
    let!(:tasks) { create_list(:task, 5) }
    before { signin(user) }

    it '#show' do
      get :show, params: { id: tasks.first.id }
      expect(flash[:error]).to be_eql('Access denied.')
    end

    it '#edit' do
      get :edit, params: { id: tasks.first.id }
      expect(flash[:error]).to be_eql('Access denied.')
    end

    it '#update' do
      put :update, params: { id: tasks.first.id, task: { name: 'Task' } }
      expect(flash[:error]).to be_eql('Access denied.')
    end

    it '#destroy' do
      delete :destroy, params: { id: tasks.first.id }
      expect(flash[:error]).to be_eql('Access denied.')
    end

    it '#start' do
      put :start, params: { id: tasks.first.id }
      expect(flash[:error]).to be_eql('Access denied.')
    end

    it '#finish' do
      put :finish, params: { id: tasks.first.id }
      expect(flash[:error]).to be_eql('Access denied.')
    end

    it '#reopen' do
      put :reopen, params: { id: tasks.first.id }
      expect(flash[:error]).to be_eql('Access denied.')
    end

    it '#create' do
      post :create, params: { task: { name: 'Task', user_id: tasks.first.user_id } }
      expect(Task.where(user_id: user.id).count).to be_eql(1)
    end
  end

  context '#start' do
    let!(:user) { create(:user, :admin, :activated) }
    let!(:task) { create(:task) }
    before { signin(user) }

    it 'successfully started' do
      put :start, params: { id: task.id }
      expect(task.reload.started?).to be_truthy
    end
  end

  context '#create' do
    let!(:user) { create(:user, :admin, :activated) }
    before { signin(user) }

    it 'cannot create if invalid' do
      post :create, params: { task: { name: '' } }
      expect(subject).to render_template(:new)
    end

    it 'can create' do
      expect { post :create, params: { task: { name: 'Task', user_id: user.id } } }.to change { Task.count }.from(0).to(1)
    end

    it 'can create with attachment' do
      task_attrs = {
        task: {
          name: 'Task',
          user_id: user.id,
          attachments_attributes: {
            '0': {
              attach_file: Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support_files', 'test_attachments', 'test.png'))
            }
          }
        }
      }
      expect { post :create, params: task_attrs }.to change { Attachment.count }.from(0).to(1)
    end
  end


  context '#show, #edit' do
    let!(:user) { create(:user, :admin, :activated) }
    let!(:task) { create(:task) }
    before { signin(user) }

    it 'render show' do
      get :show, params: { id: task.id }
      expect(subject).to render_template(:show)
    end

    it 'render edit' do
      get :edit, params: { id: task.id }
      expect(subject).to render_template(:edit)
    end

    it 'assign users for editing' do
      get :edit, params: { id: task.id }
      expect(assigns(:users).length).to be_eql(2)
    end
  end

  context '#new' do
    let!(:user) { create(:user, :admin, :activated) }
    before { signin(user) }

    it 'render new' do
      get :new
      expect(subject).to render_template(:new)
    end

    it 'assign users for editing' do
      get :new
      expect(assigns(:users).length).to be_eql(1)
    end
  end

  context '#update' do
    let!(:user) { create(:user, :admin, :activated) }
    let!(:task) { create(:task) }
    before { signin(user) }

    it 'cannot update if valid' do
      put :update, params: { id: task.id, task: { name: nil } }
      expect(subject).to render_template(:edit)
    end

    it 'can update' do
      put :update, params: { id: task.id, task: { name: 'NewName' } }
      expect(task.reload.name).to be_eql('NewName')
    end
  end


  context '#destroy' do
    let!(:user) { create(:user, :admin, :activated) }
    let!(:task) { create(:task) }
    before { signin(user) }

    it 'successfully destroy' do
      expect { delete :destroy, params: { id: task.id } }.to change { Task.count }.from(1).to(0)
    end
  end

  context '#finish' do
    let!(:user) { create(:user, :admin, :activated) }
    let!(:task) { create(:task) }
    before { signin(user) }

    it 'successfully finished' do
      put :start, params: { id: task.id }
      put :finish, params: { id: task.id }
      expect(task.reload.finished?).to be_truthy
    end
  end

  context '#reopen' do
    let!(:user) { create(:user, :admin, :activated) }
    let!(:task) { create(:task) }
    before { signin(user) }

    it 'successfully reopened after start' do
      put :start, params: { id: task.id }
      put :reopen, params: { id: task.id }
      expect(task.reload.new?).to be_truthy
    end

    it 'successfully reopened after finished' do
      put :start, params: { id: task.id }
      put :finish, params: { id: task.id }
      put :reopen, params: { id: task.id }
      expect(task.reload.new?).to be_truthy
    end
  end
end
