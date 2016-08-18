require 'rails_helper'

describe Web::Tasks::AttachmentsController do
  context'unauthenticated' do
    let!(:attachment) { create(:attachment) }

    it '#show' do
      get :show, params: { task_id: attachment.task.id, id: attachment.id }
      expect(response).to redirect_to(new_session_path)
    end
  end

  context 'authenticated, but unauthorized' do
    let!(:user) { create(:user) }
    let!(:attachment) { create(:attachment) }
    before { signin(user) }

    it '#show' do
      get :show, params: { task_id: attachment.task.id, id: attachment.id }
      expect(flash[:error]).to be_eql('Access denied.')
    end
  end

  context 'authenticated and authorized' do
    let!(:user) { create(:user) }
    let(:attachment) { create(:attachment, task: create(:task, user: user)) }
    before { signin(user) }

    it '#show' do
      get :show, params: { task_id: attachment.task.id, id: attachment.id }
      expect(response.status).to eq(200)
    end

    describe 'download' do
      it '#show' do
        get :show, params: { task_id: attachment.task.id, id: attachment.id }
        expect(controller.headers['Content-Transfer-Encoding']).to be_eql('binary')
      end
    end

    describe 'display' do
      let!(:attachment) { create(:attachment, :image, task: create(:task, user: user)) }
      it '#show' do
        get :show, params: { task_id: attachment.task.id, id: attachment.id }
        expect(controller.headers['Content-Transfer-Encoding']).to be_eql('binary')
      end
    end
  end
end
