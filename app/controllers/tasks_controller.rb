# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :load_task, only: [:show, :update]

  def index
    # render html: "This is index action of Tasks controller"

    tasks = Task.all
    render status: :ok, json: { tasks: tasks }
    # respond_to do |format|
    #   format.html
    #   format.xml { render xml: @tasks }
    #   format.json { render json: @tasks }
    # end
  end

  def create
    task = Task.new(task_params)
    if task.save
      render status: :ok, json: { notice: "Task was successfully created" }
    else
      errors = task.errors.full_messages.to_sentence
      render status: :unprocessable_entity, json: { error: errors }
    end
  end

  def show
    render status: :ok, json: { task: @task }
  end

  def update
    if @task && @task.update(task_params)
      render status: :ok, json: { notice: "Successfully updated task." }
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
      params.require(:task).permit(:title)
    end
end
