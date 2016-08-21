# frozen_string_literal: true
class TaskPolicy
  attr_reader :current_user, :model

  def initialize(current_user, model)
    @current_user = current_user
    @task = model
  end

  def index?
    true
  end

  def show?
    @current_user.admin? || @current_user == @task.user
  end

  def new?
    true
  end

  def create?
    true
  end

  def edit?
    @current_user.admin? || @current_user == @task.user
  end

  def update?
    @current_user.admin? || @current_user == @task.user
  end

  def destroy?
    @current_user.admin? || @current_user == @task.user
  end

  def start?
    @current_user.admin? || @current_user == @task.user
  end

  def reopen?
    @current_user.admin? || @current_user == @task.user
  end

  def finish?
    @current_user.admin? || @current_user == @task.user
  end
end
