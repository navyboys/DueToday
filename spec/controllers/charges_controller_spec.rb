require 'rails_helper'

RSpec.describe ChargesController, type: :controller do
  describe 'GET new' do
    it 'render new template' do
      set_current_user(Fabricate(:user))
      get :new
      expect(response).to render_template :new
    end

    it_behaves_like 'requires sign in' do
      let(:action) do
        get :new
      end
    end
  end

  describe 'POST create' do
    it 'render create template', :vcr do
      set_current_user(Fabricate(:user))
      allow(StripeWrapper::Charge).to receive(:create)
      post :create
      expect(response).to render_template :create
    end
  end
end
