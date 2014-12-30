require 'rails_helper'

RSpec.describe SummariesController, type: :controller do
  describe 'POST create' do
    let(:navy) { Fabricate(:user) }

    context 'with authenticated users' do
      before do
        set_current_user(navy)
        post :create, summary: Fabricate.attributes_for(:summary)
      end

      it 'redirects to todos_today page' do
        expect(response).to redirect_to todos_today_path
      end

      it 'creates a summary' do
        expect(Summary.count).to eq(1)
      end

      it 'creates a summary accociated with the signed in user' do
        expect(Summary.last.user).to eq(navy)
      end
    end

    it_behaves_like 'requires sign in' do
      let(:action) { post :create }
    end
  end
end
