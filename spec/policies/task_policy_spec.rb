# frozen_string_literal: true
require 'rails_helper'

describe TaskPolicy do
  subject { TaskPolicy }

  let(:current_user) { create(:user, :activated) }
  let(:cu_task) { create(:task, user: current_user) }
  let(:other_user) { create(:user, :activated) }
  let(:ou_task) { create(:task, user: other_user) }
  let(:admin) { create(:user, :activated, :admin) }

  permissions :index? do
    it 'allows access for anybody' do
      expect(TaskPolicy).to permit(current_user)
    end
    it 'allows access for an admin' do
      expect(TaskPolicy).to permit(admin)
    end
  end

  permissions :show? do
    it 'prevents other users from seeing your tasks' do
      expect(subject).not_to permit(current_user, ou_task)
    end
    it 'allows you to see your own tasks' do
      expect(subject).to permit(current_user, cu_task)
    end
    it 'allows an admin to see any task' do
      expect(subject).to permit(admin)
    end
  end

  permissions :create? do
    it 'allows anybody to create a new task' do
      expect(subject).to permit(current_user)
    end
    it 'allows an admin to create a task' do
      expect(subject).to permit(admin)
    end
  end

  permissions :new? do
    it 'allows anybody to create a new task' do
      expect(subject).to permit(current_user)
    end
    it 'allows an admin to create a task' do
      expect(subject).to permit(admin)
    end
  end

  permissions :update? do
    it 'prevents other users from updating your task' do
      expect(subject).not_to permit(current_user, ou_task)
    end
    it 'allows you to update your own task' do
      expect(subject).to permit(current_user, cu_task)
    end
    it 'allows an admin to make updates' do
      expect(subject).to permit(admin)
    end
  end

  permissions :edit? do
    it 'prevents other users from editing your task' do
      expect(subject).not_to permit(current_user, ou_task)
    end
    it 'allows you to editing your own task' do
      expect(subject).to permit(current_user, cu_task)
    end
    it 'allows an admin to make updates' do
      expect(subject).to permit(admin)
    end
  end

  permissions :start? do
    it 'prevents other users from starting your task' do
      expect(subject).not_to permit(current_user, ou_task)
    end
    it 'allows you to starting your own task' do
      expect(subject).to permit(current_user, cu_task)
    end
    it 'allows an admin to start any task' do
      expect(subject).to permit(admin)
    end
  end

  permissions :reopen? do
    it 'prevents other users from reopening your task' do
      expect(subject).not_to permit(current_user, ou_task)
    end
    it 'allows you to reopen your own task' do
      expect(subject).to permit(current_user, cu_task)
    end
    it 'allows an admin to reopen any task' do
      expect(subject).to permit(admin)
    end
  end

  permissions :finish? do
    it 'prevents other users from finishing your task' do
      expect(subject).not_to permit(current_user, ou_task)
    end
    it 'allows you to finishing your own task' do
      expect(subject).to permit(current_user, cu_task)
    end
    it 'allows an admin to finish any task' do
      expect(subject).to permit(admin)
    end
  end

  permissions :destroy? do
    it 'allows deleting your task' do
      expect(subject).to permit(current_user, cu_task)
    end
    it 'prevents other users from deleting your task' do
      expect(subject).not_to permit(current_user, ou_task)
    end
    it 'allows an admin to delete any task' do
      expect(subject).to permit(admin, ou_task)
    end
  end
end
