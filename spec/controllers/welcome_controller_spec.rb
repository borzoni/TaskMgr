require 'rails_helper'

describe Web::WelcomeController do
  context '#index' do
    let!(:tasks) { create_list(:task, 5) }

    it 'renders view' do
      get :index
      expect(subject).to render_template(:index)
    end
  end
end
