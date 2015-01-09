class TodosController < ApplicationController
  before_action :require_user

  def index_today
    @todo = Todo.new
  end

  def index_previous_day
    @summary = Summary.new
  end

  def history
  end

  def search
    if params[:from] > params[:to]
      flash[:error] = 'Date(To) must be latter than Date(From).'
    else
      @dates = current_user.active_days(params[:from], params[:to])
    end

    render json: {
      update: {
        'history-list' => render_to_string(
          partial: 'todos/history_list',
          layout: false,
          locals: {
            dates: @dates
          })
      }
    }
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
    @todo.update_attribute(:status, params[:format])
    redirect_to :back
  end

  def copy_to_today
    todo = Todo.find(params[:id])
    todo.copy_to_today
    redirect_to :back
  end

  private

  def todo_params
    params.require(:todo).permit(:title, :status, :due, :user_id)
  end
end
