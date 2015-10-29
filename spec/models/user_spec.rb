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

    it 'returns all active days between the from and to date when both exsit in chronological order' do
      active_due_days = get_due_days(navy.active_days(today - 8, today - 1))
      expect(active_due_days).to eq([todo_yestoday.due, todo_last_week.due])
    end

    it 'returns all active days when from and to are both missing' do
      active_due_days = get_due_days(navy.active_days('', ''))
      expect(active_due_days).to eq([todo_today.due, todo_yestoday.due, todo_last_week.due])
    end

    it 'returns active days before the to date when from is missing' do
      active_due_days = get_due_days(navy.active_days('', today - 1))
      expect(active_due_days).to eq([todo_yestoday.due, todo_last_week.due])
    end

    it 'returns active days after the from date when to is missing' do
      active_due_days = get_due_days(navy.active_days(today - 6, ''))
      expect(active_due_days).to eq([todo_today.due, todo_yestoday.due])
    end

    it 'returns blank array when the user has no todo' do
      expect(navy.active_days(today + 1, today + 2)).to eq([])
    end
  end

  describe '#day_job_processed?(date)' do
    let(:navy) { Fabricate(:user) }
    let(:date) { Date.today - 1 }

    it 'returns true when date is nil' do
      expect(navy.day_job_processed?(nil)).to eq(true)
    end

    it 'returns false when there are tasks still open' do
      Fabricate(:todo, user: navy, due: date, status: 'open')
      Fabricate(:summary, user: navy, date: date, description: '')
      expect(navy.day_job_processed?(date)).to eq(false)
    end

    it 'returns false when there is no summary existed that day' do
      Fabricate(:todo, user: navy, due: date, status: 'completed')
      expect(navy.day_job_processed?(date)).to eq(false)
    end

    it 'returns false when summary description is null' do
      Fabricate(:todo, user: navy, due: date, status: 'completed')
      Fabricate(:summary, user: navy, date: date, description: '')
      expect(navy.day_job_processed?(date)).to eq(false)
    end

    it 'returns ture when there is no open tasks remained and summary is not null' do
      Fabricate(:todo, user: navy, due: date, status: 'completed')
      Fabricate(:summary, user: navy, date: date, description: 'Well Done.')
      expect(navy.day_job_processed?(date)).to eq(true)
    end
  end
end
