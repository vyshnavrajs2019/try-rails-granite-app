# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :authenticate_user_using_x_auth_token
  before_action :load_task, only: [:show, :update, :destroy]
  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index

  def index
    # render html: "This is index action of Tasks controller"

    # tasks = Task.all
    # @tasks = TaskPolicy::Scope.new(current_user, Task).resolve
    tasks = policy_scope(Task)
    render status: :ok, json: { tasks: tasks }
    # respond_to do |format|
    #   format.html
    #   format.xml { render xml: @tasks }
    #   format.json { render json: @tasks }
    # end
  end

  def create
    @task = Task.new(task_params.merge(creator_id: @current_user.id))
    if @task.save
      render status: :ok, json: { notice: "Task was successfully created." }
    else
      errors = @task.errors.full_messages.to_sentence
      render status: :unprocessable_entity, json: { error: errors }
    end
  end

  def show
    authorize @task
    # render status: :ok, json: { task: @task, assigned_user: @task.user }
    @task_creator = User.find(@task.creator_id).name
  end

  def update
    authorize @task
    if @task && @task.update(task_params)
      render status: :ok, json: { notice: "Successfully updated task." }
    else
      render status: :unprocessable_entity,
        json: { error: @task.errors.full_messages.to_sentence }
    end
  end

  def destroy
    authorize @task
    if @task.destroy
      render status: :ok, json: { notice: "Successfully deleted task." }
    else
      render status: :unprocessable_entity,
        json: { error: @task.errors.full_messages.to_sentence }
    end
  end

  private

    def load_task
      @task = Task.find_by(slug: params[:slug])
      unless @task
        render status: :not_found, json: { error: "Task not found" }
      end
    end

    def task_params
      params.require(:task).permit(:title, :user_id)
    end
end
