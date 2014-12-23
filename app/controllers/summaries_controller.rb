class SummariesController < ApplicationController
  before_action :require_user

  def create
    @todo = current_user.summaries.build(summary_params)
    @todo.save
    redirect_to todos_today_path
  end

  private

  def summary_params
    params.require(:summary).permit(:date, :description)
  end
end
