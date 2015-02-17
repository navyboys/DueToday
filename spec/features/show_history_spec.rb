require 'rails_helper'

feature 'show history' do
  scenario 'find history by date range, show results with pagination' do
    navy = Fabricate(:user)
    6.times do |i|
      Fabricate(:todo, user: navy, due: Date.today - i, status: 'completed')
      Fabricate(:summary, user: navy, date: Date.today - i)
    end
    todo_today = Todo.first

    sign_in(navy)
    click_link 'Show History'

    # show history with pagination
    click_button 'Find'
    expect(page).to have_content todo_today[:name]
    expect(page).to have_content 'Next'
    expect(page).to have_content 'Last'

    # link to today page
    visit history_path
    click_link 'Back to Today'
    expect(find(:xpath, "//input[@type='submit']").value).to eq('Add')
  end
end
