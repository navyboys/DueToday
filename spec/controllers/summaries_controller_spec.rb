require 'rails_helper'

RSpec.describe SummariesController, type: :controller do
  describe 'POST create' do
    let(:navy) { Fabricate(:user) }

    context 'with authenticated users' do
      let(:date) { Date.today - 1 }
      let(:params) do
        {
          user: navy,
          date: date,
          description: 'Well Done.'
        }
      end

      before do
        set_current_user(navy)
        request.env['HTTP_REFERER'] = todos_previous_day_path
      end

      it 'shows error message when open todos exsit' do
        Fabricate(:todo, user: navy, due: date, status: 'open')
        post :create, summary: params
        expect(flash[:error]).to eq('Process all your todos first.')
      end

      it 'shows error message when description is blank' do
        params[:description] = ''
        post :create, summary: params
        expect(flash[:error]).to eq('Add your summary about the day.')
      end

      it 'redirects to original page when error occurs' do
        Fabricate(:todo, user: navy, due: date, status: 'open')
        post :create, summary: params
        expect(response).to redirect_to todos_previous_day_path
      end

      context 'created successfully' do
        before do
          post :create, summary: params
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
    end

    it_behaves_like 'requires sign in' do
      let(:action) { post :create }
    end
  end

  describe 'PATCH update' do
    let(:navy) { Fabricate(:user) }
    let(:summary_yestoday) { Fabricate(:summary, user: navy, date: Date.today - 1) }

    context 'with authenticated users' do
      before do
        set_current_user(navy)
      end

      it 'shows error message when description is blank' do
        summary_yestoday[:description] = ''
        patch :update, id: summary_yestoday, summary: summary_yestoday.attributes
        expect(flash[:error]).to eq('Add your summary about the day.')
      end

      it 'redirects to original page when error occurs' do
        summary_yestoday[:description] = ''
        patch :update, id: summary_yestoday, summary: summary_yestoday.attributes
        expect(response).to render_template('todos/index_previous_day')
      end

      it 'shows notice message when successfully updated' do
        patch :update, id: summary_yestoday, summary: summary_yestoday.attributes
        expect(flash[:notice]).to eq('Description updated.')
      end

      it 'redirects to index_today page' do
        patch :update, id: summary_yestoday, summary: summary_yestoday.attributes
        expect(response).to redirect_to todos_today_path
      end

      it "changes summary's description with params" do
        summary_yestoday[:description] = 'Description changed.'
        patch :update, id: summary_yestoday, summary: summary_yestoday.attributes
        expect(Summary.first.description).to eq('Description changed.')
      end
    end

    it_behaves_like 'requires sign in' do
      let(:action) do
        patch :update, id: summary_yestoday, summary: summary_yestoday.attributes
      end
    end
  end
end
