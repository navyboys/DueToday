require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  describe 'GET new' do
    it 'render the new template for unauthenticated users' do
      get :new
      expect(response).to render_template :new
    end

    it 'redirects to home page for authenticated users' do
      session[:user_id] = Fabricate(:user).id
      get :new
      expect(response).to redirect_to home_path
    end
  end

  describe 'POST create' do
    context 'with valid credentials' do
      let(:alice) { Fabricate(:user) }

      before do
        post :create, email: alice.email, password: alice.password
      end

      it 'puts the signed in user in the session' do
        expect(session[:user_id]).to eq(alice.id)
      end

      it 'redirects to home page' do
        expect(response).to redirect_to home_path
      end
    end

    context 'with invalid credentials' do
      before do
        post :create, email: 'wrong@todotoday.com', password: 'wrong'
      end

      it 'does not put the signed in user in the session' do
        expect(session[:user_id]).to be_nil
      end

      it 'redirects to sign in page' do
        expect(response).to redirect_to sign_in_path
      end

      it 'sets error message' do
        expect(flash[:error]).not_to be_blank
      end
    end
  end

  describe 'GET destroy' do
    before do
      session[:user_id] = Fabricate(:user).id
      get :destroy
    end

    it 'clears the session for the user' do
      expect(session[:user_id]).to be_nil
    end

    it 'redirects to root path' do
      expect(response).to redirect_to root_path
    end
  end
end
