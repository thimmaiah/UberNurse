

Given(/^I am at the login page$/) do
  visit("/")
  click_on("Login")
  sleep(1)
end

When(/^I fill and submit the login page$/) do
  fill_in('email', with: @user.email)
  fill_in('password', with: @user.email)
  click_on("Login")
  sleep(1)
end

When(/^I fill the password incorrectly and submit the login page$/) do
  fill_in('email', with: @user.email)
  fill_in('password', with: "Wrong pass")
  click_on("Login")
  sleep(1)
end
