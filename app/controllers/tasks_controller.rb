# frozen_string_literal: true

class TasksController < ApplicationController
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
end
