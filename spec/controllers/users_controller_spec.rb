require 'rails_helper'
require 'sidekiq/testing'
Sidekiq::Testing.inline!

RSpec.describe UsersController, type: :controller do
  describe 'GET new' do
    it 'assigns @user' do
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end
  end

  describe 'POST create' do
    context 'with valid input' do
      before { post :create, user: Fabricate.attributes_for(:user) }

      it 'assigns @user' do
        expect(assigns(:user)).to be_instance_of(User)
      end

      it 'creates the user' do
        expect(User.count).to eq(1)
      end

      it 'redirects to sign in page' do
        expect(response).to redirect_to sign_in_path
      end
    end

    context 'with invalid input' do
      before { post :create, user: { password: 'password' } }

      it 'does not create the user' do
        expect(User.count).to eq(0)
      end

      it 'render the :new template' do
        expect(response).to render_template :new
      end
    end

    context 'sending emails' do
      after { ActionMailer::Base.deliveries.clear }

      it 'sends out email to the user with valid inputs' do
        post :create, user: { email: 'leon@example.com', password: 'password', name: 'Leon Zheng' }
        expect(ActionMailer::Base.deliveries.last.to).to eq(['leon@example.com'])
      end

      it "sends out email containing the user's name with valid inputs" do
        post :create, user: { email: 'leon@example.com', password: 'password', name: 'Leon Zheng' }
        expect(ActionMailer::Base.deliveries.last.body).to include('Leon Zheng')
      end

      it 'does not send out email with invalid inputs' do
        post :create, user: { email: 'leon@example.com' }
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end
  end
end
