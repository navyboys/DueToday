require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'GET new' do
    it 'assigns @user' do
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end
  end

  describe 'POST create' do
    context 'with valid input' do
      it 'creates the user'
      it 'redirects to sign in page'
    end

    context 'with invalid input' do
      it 'does not create the user'
      it 'render the :new template'
      it 'sets @user'
    end
  end
end
