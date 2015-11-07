require 'rails_helper'

RSpec.describe PasswordResetsController, type: :controller do
  describe 'GET show' do
    it 'renders show template if the token is valid' do
      leon = Fabricate(:user, token: '12345')
      get :show, id: '12345'
      expect(response).to render_template :show
    end

    it 'set @token' do
      leon = Fabricate(:user, token: '12345')
      get :show, id: '12345'
      expect(assigns(:token)).to eq('12345')
    end

    it 'redirects to the expired token page if the token is not valid' do
      get :show, id: '12345'
      expect(response).to redirect_to expired_token_path
    end
  end

  describe 'POST create' do
    context 'with valid token' do
      let(:leon) { Fabricate(:user, password: 'old_password') }
      before do
        leon.update_column(:token, '12345')
        post :create, token: '12345', password: 'new_password'
      end

      it 'redirects to the sign in page' do
        expect(response).to redirect_to sign_in_path
      end

      it "update the user's password" do
        expect(leon.reload.authenticate('new_password')).to be_truthy
      end

      it 'sets the flash success message' do
        expect(flash[:success]).to eq('Your password has been changed. Please sign in.')
      end

      it 'delete the user token' do
        expect(leon.reload.token).to be_nil
      end
    end

    context 'with invalid token' do
      it 'redirects to the expired toen path' do
        post :create, token: '12345', password: 'new_password'
        expect(response).to redirect_to expired_token_path
      end
    end
  end
end