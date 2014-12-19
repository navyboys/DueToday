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
    let(:ben) { Fabricate(:user) }

    context 'with authenticated users' do
      before { set_current_user(ben) }

      context 'with valid input' do
        before { post :create, todo: Fabricate.attributes_for(:todo) }

        it 'creates a todo' do
          expect(Todo.count).to eq(1)
        end

        it 'creates a todo accociated with the signed in user' do
          expect(Todo.last.user).to eq(ben)
        end
      end

      context 'with invalid input' do
        before { post :create, todo: { title: nil } }

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
    let(:ben) { Fabricate(:user) }
    let(:cook_dinner) { Fabricate(:todo, user: ben) }

    context 'with authenticated users' do
      before do
        set_current_user(ben)
        request.env['HTTP_REFERER'] = todos_today_path
        delete :destroy, id: cook_dinner
      end

      it 'redirects to original page' do
        expect(response).to redirect_to todos_today_path
      end

      it 'deletes the todo' do
        expect(Todo.count).to eq(0)
      end
    end

    it_behaves_like 'requires sign in' do
      let(:action) { delete :destroy, id: cook_dinner }
    end
  end

  describe 'PATCH update' do
    let(:ben) { Fabricate(:user) }
    let(:cook_dinner) { Fabricate(:todo, user: ben) }

    context 'with authenticated users' do
      before do
        set_current_user(ben)
        request.env['HTTP_REFERER'] = todos_today_path
        cook_dinner.status = 'completed'
        patch :update, id: cook_dinner, todo: cook_dinner.attributes
      end

      it 'redirects to the original page' do
        expect(response).to redirect_to todos_today_path
      end

      it "changes todo's status with params" do
        expect(Todo.first.status).to eq('completed')
      end
    end

    it_behaves_like 'requires sign in' do
      let(:action) do
        patch :update, id: cook_dinner, todo: cook_dinner.attributes
      end
    end
  end

  describe 'POST copy_to_today' do
    let(:ben) { Fabricate(:user) }
    let(:cook_dinner) { Fabricate(:todo, user: ben) }

    context 'with authenticated users' do
      before do
        set_current_user(ben)
        request.env['HTTP_REFERER'] = todos_previous_day_path
        post :copy_to_today, id: cook_dinner, todo: cook_dinner.attributes
      end

      it 'redirects to the original page' do
        expect(response).to redirect_to todos_previous_day_path
      end

      it 'copies a todo with same title due to today' do
        expect(Todo.count).to eq(2)
        expect(Todo.last.title).to eq(cook_dinner.title)
      end
    end

    it_behaves_like 'requires sign in' do
      let(:action) do
        post :copy_to_today, id: cook_dinner, todo: cook_dinner.attributes
      end
    end
  end
end
