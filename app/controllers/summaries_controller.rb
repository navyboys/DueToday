class SummariesController < ApplicationController
  before_action :require_user

  def create
    if current_user.todos.where(due: current_user.previous_day, status: 'open').count != 0
      flash[:error] = 'Process all your todos first.'
      redirect_to :back
    elsif params[:summary][:description].blank?
      flash[:error] = 'Add your summary about the day.'
      redirect_to :back
    else
      @summary = current_user.summaries.build(summary_params)
      @summary.save
      redirect_to todos_today_path
    end
  end

  def update
    @summary = Summary.find params[:id]
    if params[:summary][:description].blank?
      flash[:error] = 'Add your summary about the day.'
      render 'todos/index_previous_day'
    elsif @summary.update_attributes(summary_params)
      flash[:notice] = 'Description updated.'
      redirect_to todos_today_path
    end
  end

  private

  def summary_params
    params.require(:summary).permit(:date, :description)
  end
end
