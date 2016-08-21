# frozen_string_literal: true
Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  scope module: 'web' do
    root 'welcome#index'
    resources :sessions, only: [:new, :create, :destroy] do
      root 'sessions#new' # just to round everything up
    end
    resources :registrations, only: [:new, :create] do
      root 'registrations#new'
    end
    resources :password_resets, only: [:new, :create, :edit, :update] do
      root 'password_resets#new'
    end
    resources :account_activations, only: [:edit] do
      root 'account_activations#edit'
    end

    resources :users
    namespace :profile do
      root 'tasks#index'
      resources :tasks, only: :index
    end

    resources :tasks, except: :index do
      root 'profile/tasks#index'
      put :start, on: :member
      put :finish, on: :member
      put :reopen, on: :member
      scope module: 'tasks' do
        resources :attachments, only: :show
      end
    end
  end
end
