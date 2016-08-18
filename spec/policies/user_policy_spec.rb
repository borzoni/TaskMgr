require 'rails_helper'

describe UserPolicy do
  subject { UserPolicy }

  let(:current_user) { create(:user, :activated) }
  let(:other_user) { create(:user, :activated) }
  let(:admin) { create(:user, :activated, :admin) }

  permissions :index? do
    it 'denies access if not an admin' do
      expect(UserPolicy).not_to permit(current_user)
    end
    it 'allows access for an admin' do
      expect(UserPolicy).to permit(admin)
    end
  end

  permissions :show? do
    it 'prevents other users from seeing your profile' do
      expect(subject).not_to permit(current_user, other_user)
    end
    it 'allows you to see your own profile' do
      expect(subject).to permit(current_user, current_user)
    end
    it 'allows an admin to see any profile' do
      expect(subject).to permit(admin)
    end
  end

  permissions :create? do
    it 'prevents other users from creating new profiles' do
      expect(subject).not_to permit(current_user)
    end
    it 'allows an admin to create profiles' do
      expect(subject).to permit(admin)
    end
  end

  permissions :new? do
    it 'prevents other users from creating new profiles' do
      expect(subject).not_to permit(current_user)
    end
    it 'allows an admin to create profiles' do
      expect(subject).to permit(admin)
    end
  end

  permissions :update? do
    it 'prevents other users from updating your profile' do
      expect(subject).not_to permit(current_user, other_user)
    end
    it 'allows you to update your own profile' do
      expect(subject).to permit(current_user, current_user)
    end
    it 'allows an admin to make updates' do
      expect(subject).to permit(admin)
    end
  end

  permissions :edit? do
    it 'prevents other users from editing your profile' do
      expect(subject).not_to permit(current_user, other_user)
    end
    it 'allows you to editing your own profile' do
      expect(subject).to permit(current_user, current_user)
    end
    it 'allows an admin to make updates' do
      expect(subject).to permit(admin)
    end
  end

  permissions :destroy? do
    it 'prevents deleting yourself' do
      expect(subject).not_to permit(current_user, current_user)
    end
    it 'allows an admin to delete any user' do
      expect(subject).to permit(admin, other_user)
    end
  end
end
