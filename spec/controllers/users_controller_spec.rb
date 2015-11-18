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
        post :create, user: { email: 'navy@example.com', password: 'password', name: 'navy Zheng' }
        expect(ActionMailer::Base.deliveries.last.to).to eq(['navy@example.com'])
      end

      it "sends out email containing the user's name with valid inputs" do
        post :create, user: { email: 'navy@example.com', password: 'password', name: 'navy Zheng' }
        expect(ActionMailer::Base.deliveries.last.body).to include('navy Zheng')
      end

      it 'does not send out email with invalid inputs' do
        post :create, user: { email: 'navy@example.com' }
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end
  end

  describe 'GET edit' do
    let(:navy) { Fabricate(:user) }

    context 'with authenticated users' do
      it 'assigns @user' do
        set_current_user(navy)
        get :edit, id: navy.id
        expect(assigns(:user)).to eq(navy)
      end
    end

    it_behaves_like 'requires sign in' do
      let(:action) { get :edit, id: navy.id }
    end
  end

  describe 'PATCH update' do
    let(:navy) { Fabricate(:user, name: 'old_name', password: 'old_password') }

    context 'with authenticated users' do
      before do
        set_current_user(navy)
      end

      context 'update failed' do
        it 'redirects to edit page when error occurs' do
          patch :update, id: navy.id, user: { name: '', password: '' }
          expect(response).to render_template :edit
        end
      end

      context 'update successfully' do
        before { patch :update, id: navy.id, user: { name: 'new_name', password: 'new_password' } }

        it 'shows notice message when successfully updated' do
          expect(flash[:info]).to eq('Your profile was updated.')
        end

        it 'redirects to todos due today page' do
          expect(response).to redirect_to profile_path
        end

        it 'changes name with params' do
          expect(User.first.name).to eq('new_name')
        end

        it 'changes password with params' do
          expect(User.first.authenticate('new_password')).to eq(User.first)
        end
      end
    end

    it_behaves_like 'requires sign in' do
      let(:action) do
        patch :update, id: navy.id, user: { name: 'new_name', password: 'new_password' }
      end
    end
  end
end
