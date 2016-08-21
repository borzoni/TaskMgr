# frozen_string_literal: true
class Web::TasksController < Web::ApplicationController
  before_action :assert_auth
  after_action :verify_authorized

  before_action :load_task, only: %i(show edit update destroy start reopen finish)
  before_action :load_users, only: %i(index new edit)
  before_action :prepare_bread, except: %i(destroy start finish reopen)

  def show
    authorize @task
  end

  def new
    @task = Task.new.tap(&:build_attachments)
    authorize Task
  end

  def create
    authorize Task
    @task = Task.new(task_params)
    if @task.save
      flash[:success] = "Task #{@task.name} succesfully created"
      redirect_to task_path(@task)
    else
      load_users
      @task.build_attachments
      flash[:error] = 'Task failed to save.'
      render 'new'
    end
  end

  def edit
    authorize @task
    @task.tap(&:build_attachments)
  end

  def update
    authorize @task
    if @task.update_attributes(task_params)
      flash[:success] = "Task #{@task.name} succesfully edited"
      redirect_to task_path(@task)
    else
      load_users
      @task.build_attachments
      flash[:error] = 'Task failed to save.'
      render 'edit'
    end
  end

  def destroy
    authorize @task
    @task.destroy
    flash[:success] = "Task #{@task.name} deleted!"
    redirect_to tasks_path
  end

  def start
    process_task_transition('started') { @task.start! }
  end

  def finish
    process_task_transition('finished') { @task.finish! }
  end

  def reopen
    process_task_transition('reopened') { @task.reopen! }
  end

  private

  def process_task_transition(transitioned)
    authorize @task
    yield if block_given?
    flash[:success] = "Task #{@task.name} '#{transitioned}!"
    respond_to do |f|
      f.html { redirect_to tasks_url }
      f.js { render 'task' }
    end
  end

  def load_task
    @task = Task.find(params[:id])
  end

  def task_params
    params_temp = params.require(:task).permit(:name, :description, :user_id, attachments_attributes: [:attach_file, :attach_file_cache, :id, :_destroy])
    params_temp[:user_id] = current_user.id unless current_user.admin?
    params_temp
  end

  def load_users
    return unless current_user.admin?
    @users = User.order('email').all
  end

  def prepare_bread
    add_breadcrumb 'Profile', profile_tasks_path
    add_breadcrumb @task.name, task_path(@task) if action_name.eql?('edit')
    add_breadcrumb @task.name if action_name.eql?('show')
    add_breadcrumb 'Edit' if action_name.eql?('edit')
    add_breadcrumb 'New' if action_name.eql?('new')
  end
end
