require 'rails_helper'

RSpec.describe PasswordResetsController, type: :controller do
  describe 'GET show' do
    context 'with valid token' do
      before do
        navy = Fabricate(:user)
        navy.update_column(:token, '12345')
        get :show, id: '12345'
      end

      it 'renders show template' do
        expect(response).to render_template :show
      end

      it 'set @token' do
        expect(assigns(:token)).to eq('12345')
      end
    end

    context 'with invalid token' do
      it 'redirects to the expired token page' do
        get :show, id: '12345'
        expect(response).to redirect_to expired_token_path
      end
    end
  end

  describe 'POST create' do
    context 'with valid token' do
      let(:navy) { Fabricate(:user, password: 'old_password') }
      before do
        navy.update_column(:token, '12345')
        post :create, token: '12345', password: 'new_password'
      end

      it 'redirects to the sign in page' do
        expect(response).to redirect_to sign_in_path
      end

      it "update the user's password" do
        expect(navy.reload.authenticate('new_password')).to be_truthy
      end

      it 'sets the flash success message' do
        expect(flash[:success]).to eq('Your password has been changed. Please sign in.')
      end

      it 'delete the user token' do
        expect(navy.reload.token).to be_nil
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
