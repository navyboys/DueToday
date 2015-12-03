require 'rails_helper'

feature 'User donates' do
  scenario 'user successfully charges through stripe checkout', js: true, vcr: true do
    navy = Fabricate(:user)

    sign_in(navy)
    visit new_charge_path
    expect(page).to have_content 'Your donation will help us make DueToday even better.'

    click_button 'Pay with Card'

    stripe_iframe = all('iframe[name=stripe_checkout_app]').last
    Capybara.within_frame stripe_iframe do
      4.times { page.find('#card_number').native.send_keys('4242') }
      page.find('#cc-exp').native.send_keys('12')
      page.find('#cc-exp').native.send_keys('20')
      page.find('#cc-csc').native.send_keys('123')
      page.find('#submitButton').click
      # 4.times { page.driver.browser.find_element(:id, 'card_number').send_keys('4242') }
      # page.driver.browser.find_element(:id, 'cc-exp').send_keys '5'
      # page.driver.browser.find_element(:id, 'cc-exp').send_keys '18'
      # page.driver.browser.find_element(:id, 'cc-csc').send_keys '123'
      # page.driver.browser.find_element(:id, 'submitButton').click
    end
    sleep(3)
    expect(page).to have_content 'THANK YOU'
  end
end
