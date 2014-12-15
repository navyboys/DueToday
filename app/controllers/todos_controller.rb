class TodosController < ApplicationController
  before_action :require_user

  def index_today
  end

  def create
    @todo = current_user.todos.build(todo_params)

    if @todo.save
      redirect_to 'todos/today'
    else
      flash[:error] = 'Input title please.'
      redirect_to 'todos/today'
    end
  end

  def destroy
  end

  private

  def todo_params
    params.require(:todo).permit(:name, :status, :due, :user_id)
  end
end
