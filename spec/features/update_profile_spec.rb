require 'rails_helper'

feature 'Update Profile' do
  scenario 'user successfully updates the profile' do
    navy = Fabricate(:user, name: 'old_name', password: 'old_password')

    sign_in(navy)
    click_link 'Edit Profile'
    expect(page).to have_content 'Avatar'

    fill_in 'Name', with: 'new_name'
    fill_in 'Password', with: 'new_password'
    select '(GMT-09:00) Alaska', from: 'user_time_zone'
    attach_file 'user_avatar', 'spec/support/sample.jpg'
    click_button 'Update'
    expect(page).to have_content 'Your profile was updated.'

    click_link 'Sign Out'
    click_link 'Sign In'
    fill_in 'Email', with: navy.email
    fill_in 'Password', with: 'new_password'
    click_button 'Sign In'
    click_link 'Edit Profile'
    expect(find(:xpath, "//input[@id='user_name']").value).to eq('new_name')
    expect(page).to have_select('user_time_zone', selected: '(GMT-09:00) Alaska')
    expect(page).to have_xpath('//img[contains(@src, sample.jpg)]')
  end
end
