require 'rails_helper'

RSpec.describe Todo, type: :model do
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:status) }
  it { should validate_presence_of(:due) }

  it { should belong_to(:user) }

  describe '#copy_to_today' do
    let(:todo) { Fabricate(:todo) }

    before do
      todo.copy_to_today
    end

    it 'creates a todo' do
      expect(described_class.count).to eq(2)
    end

    it 'creates a todo due to today' do
      expect(described_class.last.due).to eq(Date.today)
    end

    it 'creates a open todo' do
      expect(described_class.last.status).to eq('open')
    end

    it 'creates a todo with the same title to the original one' do
      expect(described_class.last.title).to eq(todo.title)
    end
  end
end
