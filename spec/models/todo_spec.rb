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

  describe '.search', :elasticsearch do
    let(:refresh_index) do
      Todo.import
      Todo.__elasticsearch__.refresh_index!
    end

    context 'with title' do
      it "returns no results when there's no match" do
        Fabricate(:todo, title: 'cook dinner')
        refresh_index

        expect(Todo.search('whatever').records.to_a).to eq []
      end

      it "returns an empty array when there's no search term" do
        2.times { Fabricate(:todo) }
        refresh_index

        expect(Todo.search('').records.to_a).to eq []
      end

      it 'returns an array of 1 todo for title case insensitve match' do
        cook_dinner = Fabricate(:todo, title: 'Cook Dinner')
        Fabricate(:todo, title: 'Visit School')
        refresh_index

        expect(Todo.search('Cook Dinner').records.to_a).to eq [cook_dinner]
      end

      it 'returns an array of many todos for title match' do
        visit_school = Fabricate(:todo, title: 'Visit School')
        visit_bank = Fabricate(:todo, title: 'Visit Bank')
        refresh_index

        expect(Todo.search('visit').records.to_a).to match_array [visit_school, visit_bank]
      end
    end

    context 'multiple words must match' do
      it 'returns an array of todos where 2 words match title' do
        visit_school_1 = Fabricate(:todo, title: 'Visit School: Feb 1st')
        visit_school_2 = Fabricate(:todo, title: 'Visit School: Feb 2nd')
        Fabricate(:todo, title: 'Visit Bank')
        Fabricate(:todo, title: 'Go to School')
        refresh_index

        expect(Todo.search('Visit School').records.to_a).to match_array [visit_school_1, visit_school_2]
      end
    end
  end
end
