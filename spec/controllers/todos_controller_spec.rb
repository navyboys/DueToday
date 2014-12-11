require 'rails_helper'

RSpec.describe TodosController, type: :controller do
  describe 'GET index_today' do
    it_behaves_like "requires sign in" do
      let(:action) { get :index_today }
    end
  end

  describe 'POST create' do
    context 'with valid input' do
      it 'creates a todo'
      it 'creates a todo accociated with the signed in user'
    end

    context 'with invalid input' do
      it 'does not create a todo'
      it 'shows the error message'
    end

    it 'requires sign in'
  end

  describe 'DELETE destroy' do
    it 'redirects to original page: index_today or index_previous_day'
    it 'deletes the todo'
    it 'requires sign in'
  end

  describe 'GET index_previous_day' do
    it 'sets @todos_previous_day to todos due to the previous day of the logged in user'
    it 'requires sign in'
  end

  describe 'POST update_status' do
    it "changes todo's status with params"
    it 'refresh the index_previous_day page'
    it 'requires sign in'
  end

  describe 'POST update_summary' do
    it "changes todo's summary & rate with params"
    it 'redirects to the index_today page'
    it 'requires sign in'
  end
end
