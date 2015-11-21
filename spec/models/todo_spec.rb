require 'rails_helper'

RSpec.describe Todo, type: :model do
  it { should validate_presence_of(:title) }

  it { should belong_to(:user) }

  describe '#completed?' do
    let(:navy) { Fabricate(:user) }
    let(:todo) { Fabricate(:todo, user: navy) }

    it 'returns ture when status is completed' do
      todo.status = 'completed'
      expect(todo.completed?).to eq(true)
    end

    it 'returns false when status is not completed' do
      todo.status = 'open'
      expect(todo.completed?).to eq(false)
    end
  end

  describe '#failed?' do
    let(:navy) { Fabricate(:user) }
    let(:todo) { Fabricate(:todo, user: navy) }

    it 'returns ture when status is failed' do
      todo.status = 'failed'
      expect(todo.failed?).to eq(true)
    end

    it 'returns false when status is not completed' do
      todo.status = 'open'
      expect(todo.failed?).to eq(false)
    end
  end

  describe '#copy_to_today' do
    let(:navy) { Fabricate(:user) }
    let(:todo) { Fabricate(:todo, user: navy) }

    before do
      todo.copy_to_today
    end

    it 'creates a todo' do
      expect(described_class.count).to eq(2)
    end

    it 'creates a todo due to today' do
      expect(described_class.last.due).to eq(navy.today)
    end

    it 'creates a open todo' do
      expect(described_class.last.status).to eq('open')
    end

    it 'creates a todo with the same title to the original one' do
      expect(described_class.last.title).to eq(todo.title)
    end

    it 'creates a todo with the same user to the original one' do
      expect(described_class.last.user_id).to eq(navy.id)
    end
  end
end
