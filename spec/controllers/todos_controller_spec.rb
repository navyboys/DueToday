require 'rails_helper'

RSpec.describe TodosController, type: :controller do
  describe 'GET index_today' do
    it_behaves_like 'requires sign in' do
      let(:action) { get :index_today }
    end
  end

  describe 'GET index_previous_day' do
    it_behaves_like 'requires sign in' do
      let(:action) { get :index_previous_day }
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
      let(:action) { post :create }
    end
  end

  describe 'DELETE destroy' do
    before do
      set_current_user
      request.env['HTTP_REFERER'] = todos_today_path
      todo = Fabricate(:todo)
      delete :destroy, id: todo
    end

    it 'redirects to original page' do
      expect(response).to redirect_to todos_today_path
    end

    it 'deletes the todo' do
      expect(Todo.count).to eq(0)
    end

    it_behaves_like 'requires sign in' do
      let(:action) { delete :destroy, id: Fabricate(:todo) }
    end
  end

  describe 'PATCH update' do
    before do
      set_current_user
      request.env['HTTP_REFERER'] = todos_today_path
      todo = Fabricate(:todo)
      todo.status = 'completed'
      patch :update, id: todo, todo: todo.attributes
    end

    it 'redirects to the original page' do
      expect(response).to redirect_to todos_today_path
    end

    it "changes todo's status with params" do
      expect(Todo.first.status).to eq('completed')
    end

    it_behaves_like 'requires sign in' do
      let(:action) do
        todo = Fabricate(:todo)
        patch :update, id: todo, todo: todo.attributes
      end
    end
  end
end
