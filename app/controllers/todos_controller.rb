class TodosController < ApplicationController
  before_action :require_user

  def index_today
  end

  def index_previous_day
  end

  def create
    @todo = current_user.todos.build(todo_params)
    flash[:error] = 'Input title please.' unless @todo.save
    redirect_to todos_today_path
  end

  def destroy
    todo = Todo.find(params[:id])
    todo.destroy
    redirect_to :back
  end

  def update
    @todo = Todo.find(params[:id])
    @todo.update_attribute(:status, params[:todo][:status])
    redirect_to :back
  end

  private

  def todo_params
    params.require(:todo).permit(:title, :status, :due, :user_id)
  end
end
