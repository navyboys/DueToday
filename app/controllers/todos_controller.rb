class TodosController < ApplicationController
  before_action :require_user

  def index_today
    if current_user.day_job_processed?(current_user.previous_day)
      @todo = Todo.new
    else
      redirect_to todos_previous_day_path
    end
  end

  def index_previous_day
    if current_user.summaries.where(date: current_user.previous_day).count != 0
      @summary = current_user.summaries.where(date: current_user.previous_day).first
    else
      @summary = Summary.new
    end
  end

  def history
    show_histories unless params[:commit].blank?
  end

  def search
    show_histories
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

  def show_histories
    @dates = current_user.active_days(params[:from], params[:to]).page params[:page]
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
end
