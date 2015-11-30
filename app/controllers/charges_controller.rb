class ChargesController < ApplicationController
  before_action :require_user

  def new
  end

  def create
    StripeWrapper::Charge.create(
      card:        params[:stripeToken],
      amount:      100,
      description: "DueToday user: #{current_user.email}"
    )
  end
end
