require 'rails_helper'

RSpec.describe TodosController, type: :controller do
  describe 'GET index_today' do
    it_behaves_like 'requires sign in' do
      let(:action) { get :index_today }
    end
  end

  describe 'POST create' do
    context 'with authenticated users' do
      let(:current_user) { Fabricate(:user) }
      before { session[:user_id] = current_user.id }

      context 'with valid input' do
        before { post :create, todo: Fabricate.attributes_for(:todo) }

        it 'creates a todo' do
          expect(Todo.count).to eq(1)
        end

        it 'creates a todo accociated with the signed in user' do
          expect(Todo.last.user).to eq(current_user)
        end
      end

      context 'with invalid input' do
        before { post :create, todo: { name: nil } }

        it 'does not create a todo' do
          expect(Todo.count).to eq(0)
        end

        it 'shows the error message' do
          expect(flash[:error]).to be_present
        end
      end
    end

    it_behaves_like 'requires sign in' do
      let(:action) { get :index_today }
    end
  end

  describe 'DELETE destroy' do
    it 'redirects to original page: index_today or index_previous_day'
    it 'deletes the todo'

    it_behaves_like 'requires sign in' do
      let(:action) { get :index_today }
    end
  end

  describe 'GET index_previous_day' do
    it 'sets @todos_previous_day to todos due to the previous day of the logged in user'

    it_behaves_like 'requires sign in' do
      let(:action) { get :index_today }
    end
  end

  describe 'POST update_status' do
    it "changes todo's status with params"
    it 'refresh the index_previous_day page'

    it_behaves_like 'requires sign in' do
      let(:action) { get :index_today }
    end
  end

  describe 'POST update_summary' do
    it "changes todo's summary & rate with params"
    it 'redirects to the index_today page'

    it_behaves_like 'requires sign in' do
      let(:action) { get :index_today }
    end
  end
end
