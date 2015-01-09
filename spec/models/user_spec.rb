require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:email) }

  it { should have_many(:todos) }
  it { should have_many(:summaries) }

  describe '#previous_day' do
    let(:navy) { Fabricate(:user) }
    let(:today) { Date.today }

    it "returns the last todo's due date except today" do
      todo_previous_day = Fabricate(:todo, user: navy)
      todo_previous_day.update_attribute(:due, today - 2)
      Fabricate(:todo, user: navy)
      expect(navy.previous_day).to eq(today - 2)
    end

    it "returns nil when there's no todo before today" do
      expect(navy.previous_day).to eq(nil)
    end
  end

  describe '#active_days' do
    let(:navy) { Fabricate(:user) }
    let(:today) { Date.today }
    let(:todo_today) { Fabricate(:todo, user: navy) }
    let(:todo_yestoday) { Fabricate(:todo, user: navy) }
    let(:todo_last_week) { Fabricate(:todo, user: navy) }

    before do
      todo_today.update_attribute(:due, today)
      todo_yestoday.update_attribute(:due, today - 1)
      todo_last_week.update_attribute(:due, today - 7)
    end

    it 'returns an array contains all active days between the from and to date
        when both exsit in chronological order' do
      expect(navy.active_days(today - 8, today - 1)).to eq([todo_last_week.due, todo_yestoday.due])
    end

    it 'returns all active days when from and to are both missing' do
      expect(navy.active_days(nil, nil)).to eq([todo_last_week.due, todo_yestoday.due, todo_today.due])
    end

    it 'returns active days before the to date when from is missing' do
      expect(navy.active_days(nil, today - 1)).to eq([todo_last_week.due, todo_yestoday.due])
    end

    it 'returns active days after the from date when to is missing' do
      expect(navy.active_days(today - 6, nil)).to eq([todo_yestoday.due, todo_today.due])
    end

    it 'returns blank array when the user has no todo' do
      expect(navy.active_days(today + 1, today + 2)).to eq([])
    end
  end
end
