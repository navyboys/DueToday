require 'rails_helper'

RSpec.describe TodosController, type: :controller do
  describe 'GET index_today' do
    context 'with authenticated users' do
      let(:navy) { Fabricate(:user) }

      before { set_current_user(navy) }

      it 'assigns @todo' do
        get :index_today
        expect(assigns(:todo)).to be_a_new(Todo)
      end
    end

    it_behaves_like 'requires sign in' do
      let(:action) { get :index_today }
    end
  end

  describe 'GET index_previous_day' do
    context 'with authenticated users' do
      let(:navy) { Fabricate(:user) }

      before { set_current_user(navy) }

      it 'assigns @summary' do
        get :index_previous_day
        expect(assigns(:summary)).to be_a_new(Summary)
      end
    end

    it_behaves_like 'requires sign in' do
      let(:action) { get :index_previous_day }
    end
  end

  describe 'GET history' do
    it_behaves_like 'requires sign in' do
      let(:action) { get :history }
    end
  end

  describe 'POST search' do
    # context 'with authenticated users' do
    #   let(:navy) { Fabricate(:user) }
    #   let(:params) do
    #     {
    #       from: Date.today - 1,
    #       to: Date.today
    #     }
    #   end

    #   before do
    #     set_current_user(navy)
    #     request.env['HTTP_REFERER'] = todos_history_path
    #     Fabricate(:todo, user: navy)
    #     todo_yestoday = Fabricate(:todo, user: navy)
    #     todo_yestoday.due = Date.today - 1
    #     todo_the_day_before_yestoday = Fabricate(:todo, user: navy)
    #     todo_the_day_before_yestoday.due = Date.today - 2
    #   end

    #   it 'returns todos between the from and to date when both exsit' do
    #     post :search, params
    #     expect(assigns(:todos).size).to eq(2)
    #   end

    #   it 'returns all todos when from and to are both missing'
    #   it 'returns todos before the to date when from is missing'
    #   it 'returns todos after the from date when to is missing'
    # end

    it_behaves_like 'requires sign in' do
      let(:action) { post :search }
    end
  end

  describe 'POST create' do
    let(:navy) { Fabricate(:user) }

    context 'with authenticated users' do
      before { set_current_user(navy) }

      context 'with valid input' do
        before { post :create, todo: Fabricate.attributes_for(:todo) }

        it 'redirects to todos_today page' do
          expect(response).to redirect_to todos_today_path
        end

        it 'creates a todo' do
          expect(Todo.count).to eq(1)
        end

        it 'creates a todo accociated with the signed in user' do
          expect(Todo.last.user).to eq(navy)
        end
      end

      context 'with invalid input' do
        before { post :create, todo: { title: nil } }

        it 'redirects to todos_today page' do
          expect(response).to redirect_to todos_today_path
        end

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
    let(:navy) { Fabricate(:user) }
    let(:cook_dinner) { Fabricate(:todo, user: navy) }

    context 'with authenticated users' do
      before do
        set_current_user(navy)
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
    let(:navy) { Fabricate(:user) }
    let(:cook_dinner) { Fabricate(:todo, user: navy) }

    context 'with authenticated users' do
      before do
        set_current_user(navy)
        request.env['HTTP_REFERER'] = todos_today_path
        patch :update, id: cook_dinner, format: 'completed'
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
    let(:navy) { Fabricate(:user) }
    let(:cook_dinner) { Fabricate(:todo, user: navy) }

    context 'with authenticated users' do
      before do
        set_current_user(navy)
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
