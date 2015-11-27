class ChargesController < ApplicationController
  before_action :require_user

  def new
  end

  def create
    Stripe::Charge.create(
      card:        params[:stripeToken],
      amount:      100,
      description: 'Donation form DueToday user: #{current_user.email}',
      currency:    'usd'
    )
  end
end
