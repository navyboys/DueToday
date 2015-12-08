require 'rails_helper'

feature 'Authentication' do
  scenario 'user signs up, signs in and signs out' do
    navy = {
      email: 'navy@todotoday.com',
      password: 'password',
      name: 'navy'
    }

    visit sign_up_path
    fill_in 'Email', with: navy[:email]
    fill_in 'Password', with: navy[:password]
    fill_in 'Name', with: navy[:name]
    click_button 'Sign Up'
    expect(page).to have_content 'Sign In'

    fill_in 'Email', with: navy[:email]
    fill_in 'Password', with: navy[:password]
    click_button 'Sign In'
    expect(page).to have_content 'Todos due Today'

    click_link 'Sign Out'
    expect(page).to have_content 'Sign In'
  end
end
