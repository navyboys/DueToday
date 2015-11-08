require 'rails_helper'

feature 'User resets password' do
  scenario 'user successfully resets the password' do
    leon = Fabricate(:user, password: 'old_password')

    visit sign_in_path
    click_link 'Forgot Password?'
    fill_in 'email', with: leon.email
    click_button 'Send'

    open_email(leon.email)
    current_email.click_link('Reset My Password')

    fill_in 'New Password', with: 'new_password'
    click_button 'Reset'

    fill_in 'email', with: leon.email
    fill_in 'password', with: 'new_password'
    click_button 'Sign In'
    expect(page).to have_content(leon.name)
  end
end
