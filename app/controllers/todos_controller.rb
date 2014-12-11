class TodosController < ApplicationController
  before_filter :require_user

  def index_today
  end
end
