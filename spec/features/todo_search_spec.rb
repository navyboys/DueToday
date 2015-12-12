require 'rails_helper'

feature 'Todo Search', :elasticsearch do
  scenario 'user searches with title' do
    Fabricate(:todo, title: 'Visit School: Feb 1st')
    Fabricate(:todo, title: 'Visit School: Feb 2nd')
    Fabricate(:todo, title: 'Visit Bank')
    Fabricate(:todo, title: 'Go to School')
    refresh_index

    sign_in
    click_on 'Search'

    fill_in 'query', with: 'Visit School'
    select 'open', from: '_status'
    click_button 'Search'

    expect(page).to have_content('Visit School: Feb 1st')
    expect(page).to have_content('Visit School: Feb 2nd')
    expect(page).to have_no_content('Visit Bank')
  end
end

def refresh_index
  Todo.import
  Todo.__elasticsearch__.refresh_index!
end
