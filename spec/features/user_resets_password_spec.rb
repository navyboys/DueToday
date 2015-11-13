require 'rails_helper'

feature 'User resets password' do
  scenario 'user successfully resets the password' do
    navy = Fabricate(:user, password: 'old_password')

    visit sign_in_path
    click_link 'Forgot Password?'
    fill_in 'email', with: navy.email
    click_button 'Send'

    open_email(navy.email)
    current_email.click_link('Reset My Password')

    fill_in 'New Password', with: 'new_password'
    click_button 'Reset'

    fill_in 'email', with: navy.email
    fill_in 'password', with: 'new_password'
    click_button 'Sign In'
    expect(page).to have_content(navy.name)
  end
end
