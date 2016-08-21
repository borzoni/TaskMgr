# frozen_string_literal: true
class Web::UsersController < Web::ApplicationController
  before_action :assert_auth
  after_action :verify_authorized

  before_action :load_user, only: %i(show edit update destroy)
  before_action :prepare_bread, except: :destroy

  def index
    @users = User.filter(params).paginate(page: params[:page])
    authorize User
  end

  def show
    authorize @user
  end

  def new
    @user = User.new
    authorize User
  end

  def create
    authorize User
    @user = User.new(user_params)
    if @user.save
      flash[:success] = 'User created!'
      redirect_to user_url(@user)
    else
      render 'new'
    end
  end

  def edit
    authorize @user
  end

  def update
    authorize @user
    if @user.update_attributes(user_params)
      flash[:success] = 'Profile updated'
      redirect_to(current_user == @user ? user_url(@user) : users_path)
    else
      render 'edit'
    end
  end

  def destroy
    authorize @user
    @user.destroy
    flash[:success] = "User #{@user.email} deleted"
    redirect_to users_url
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end

  def load_user
    @user = User.find(params[:id])
  end

  def prepare_bread
    add_breadcrumb 'Users', users_path
    add_breadcrumb @user.id.to_s, user_path(@user) if action_name.eql?('edit')
    add_breadcrumb @user.id.to_s if action_name.eql?('show')
    add_breadcrumb 'Edit' if action_name.eql?('edit')
    add_breadcrumb 'New' if action_name.eql?('new')
  end
end
