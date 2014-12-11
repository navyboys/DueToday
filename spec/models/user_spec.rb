require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should validate_presence_of(:nick_name) }
  it { should validate_uniqueness_of(:email) }

  it { should have_many(:todos) }

  describe "#todos_today" do
    let(:navy) { Fabricate(:user) }

    it 'returns all todos due to today assigned for the user' do
      todo1 = Fabricate(:todo, user: navy)
      todo2 = Fabricate(:todo, user: navy)
      expect(navy.todos_today.count).to eq(2)
    end

    it 'returns an empty array if the user has no todos today' do
      expect(navy.todos_today).to eq([])
    end
  end
end
