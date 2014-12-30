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
end
