require 'rails_helper'

RSpec.describe Todo, type: :model do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:status) }
  it { should validate_presence_of(:due) }

  it { should belong_to(:user) }
end
