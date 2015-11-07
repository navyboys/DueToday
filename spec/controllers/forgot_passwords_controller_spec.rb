require 'rails_helper'
require 'sidekiq/testing'
Sidekiq::Testing.inline!

RSpec.describe ForgotPasswordsController, type: :controller do
  describe 'POST create' do
    context 'with blank input' do
      before { post :create, email: '' }

      it 'redirects to the forgot password page' do
        expect(response).to redirect_to forgot_password_path
      end

      it 'shows an error message' do
        expect(flash[:error]).to eq('Email cannot be blank.')
      end
    end

    context 'with existing email' do
      before do
        Fabricate(:user, email: 'leon@duetoday.com')
        post :create, email: 'leon@duetoday.com'
      end
      after { ActionMailer::Base.deliveries.clear }

      it 'redirects to the forgot password confirmation page' do
        expect(response).to redirect_to forgot_password_confirmation_path
      end

      it 'sends out an email to the email address' do
        expect(ActionMailer::Base.deliveries.last.to).to eq(['leon@duetoday.com'])
      end
    end

    context 'with non-existing email' do
      before { post :create, email: 'non-exist@duetoday.com' }

      it 'redirects to forgot password page' do
        expect(response).to redirect_to forgot_password_path
      end

      it 'shows error message' do
        expect(flash[:error]).to eq('There is no user with that email in the system.')
      end
    end
  end
end