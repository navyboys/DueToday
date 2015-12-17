class TodosController < ApplicationController
  before_action :require_user
  before_action :set_todo, only: [:update, :destroy, :copy_to_today]

  def index_today
    @todos = current_user.todos.where(due: current_user.today).order(:created_at)
    if current_user.day_job_processed?(current_user.previous_day)
      @new_todo = Todo.new
    else
      redirect_to previous_path
    end
  end

  def index_previous_day
    @previous_day = current_user.previous_day
    @todos = current_user.todos.where(due: @previous_day).order(:created_at)
    if current_user.summaries.where(date: @previous_day).count != 0
      @summary = current_user.summaries.where(date: @previous_day).first
    else
      @summary = Summary.new
    end
  end

  def history
    show_histories unless params[:commit].blank?
  end

  def search
    show_search_results unless params[:commit].blank?
  end

  def create
    @todo = current_user.todos.build(todo_params)
    flash[:danger] = 'Input title please.' unless @todo.save
    redirect_to today_path
  end

  def destroy
    @todo.destroy
    redirect_to :back
  end

  def update
    @todo.update_attribute(:status, params[:format])
    redirect_to :back
  end

  def copy_to_today
    @todo.copy_to_today
    redirect_to :back
  end

  private

  def todo_params
    params.require(:todo).permit(:title, :status, :due, :user_id)
  end

  def set_todo
    @todo = Todo.find params[:id]
  end

  def show_histories
    @dates = current_user.active_days(params[:from], params[:to]).page params[:page]
    render json: {
      update: {
        'history-list' => render_to_string(
          partial: 'todos/search_results',
          layout: false,
          locals: {
            dates: @dates,
            todos: current_user.todos,
            summaries: current_user.summaries
          })
      }
    }
  end

  def show_search_results
    options = {
      status: params[:status]
    }
    @todos = Todo.search(params[:query], options).records.order(due: :desc)
    @dates = @todos.select('DUE').group('DUE').page params[:page]
    render json: {
      update: {
        'search-results' => render_to_string(
          partial: 'todos/search_results',
          layout: false,
          locals: {
            todos: @todos,
            dates: @dates,
            summaries: current_user.summaries
          })
      }
    }
  end
end
