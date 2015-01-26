require 'rails_helper'

feature 'todo processing: previous day' do
  scenario 'show, add, complete and delete todos' do
    navy = Fabricate(:user)
    yestoday = Date.today - 1
    todo_yestoday = Fabricate(:todo, user: navy, due: yestoday)

    # show previous_day page when the day passed with unprocessed todos
    sign_in(navy)
    expect(page).to have_content yestoday
    expect(page).to have_content todo_yestoday[:title]
    expect(find(:xpath, "//input[@type='submit']").value).to eq('Submit')

    # show error when submit with blank summary description
    click_button 'Submit'
    expect(page).to have_content('Process all your todos first.')

    # complete(check) a todo
    visit todos_previous_day_path
    find("a[href='/todos/#{todo_yestoday.id}.completed'][data-method='patch']").click
    expect(page).to have_css('a.glyphicon-check')
    expect(Todo.find(todo_yestoday[:id])[:status]).to eq('completed')

    # show error when submit with open todos
    click_button 'Submit'
    expect(page).to have_content('Add your summary about the day.')

    # fail a todo
    find("a[href='/todos/#{todo_yestoday.id}.failed'][data-method='patch']").click
    expect(page).to have_css('a.glyphicon-thumbs-down')
    expect(Todo.find(todo_yestoday[:id])[:status]).to eq('failed')

    # copy a todo to today
    find("a[href='/todos/#{todo_yestoday.id}'][data-method='post']").click
    expect(Todo.count).to eq(2)

    # add summary description
    fill_in 'Description', with: 'Well Done.'
    click_button 'Submit'
    expect(page).to have_content('Todos for Today')
    expect(page).to have_content todo_yestoday[:title]
    expect(Summary.first[:description]).to eq('Well Done.')

    # update summary description
    visit todos_previous_day_path
    fill_in 'Description', with: 'Description Changed.'
    click_button 'Submit'
    expect(page).to have_content('Todos for Today')
    expect(Summary.first[:description]).to eq('Description Changed.')
  end
end
