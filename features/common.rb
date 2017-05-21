Given(/^there is a user "([^"]*)"$/) do |arg1|
  puts  arg1
  @user = FactoryGirl.build(:user)
  key_values(@user, arg1)
  @user.save!
end

Given(/^there is an unsaved user "([^"]*)"$/) do |arg1|
  puts  arg1
  @user = FactoryGirl.build(:user)
  key_values(@user, arg1)  
end

Then(/^I should see the "([^"]*)"$/) do |arg1|
  expect(page).to have_content(arg1)
end

Given(/^Im a logged in user "([^"]*)"$/) do |arg1|
  steps %Q{
    Given there is a user "#{arg1}"
    And I am at the login page
    When I fill and submit the login page
  }
end


Given(/^Im a logged in$/) do
  steps %Q{
    And I am at the login page
    When I fill and submit the login page
  }
end

Given(/^there is a hospital "([^"]*)" with an admin "([^"]*)"$/) do |hospital_args, admin_args|

  @hospital = FactoryGirl.build(:hospital)
  key_values(@hospital, hospital_args)
  @hospital.save!

  @admin = FactoryGirl.build(:user)
  key_values(@admin, admin_args)
  @admin.hospital_id = @hospital.id
  @admin.save!

end

Given(/^there is a hospital "([^"]*)" with me as admin "([^"]*)"$/) do |hospital_args, admin_args|
  steps %Q{
    Given there is a hospital "#{hospital_args}" with an admin "#{admin_args}"
  }

  @user = @admin
end


When(/^I click "([^"]*)"$/) do |arg1|
  click_on(arg1)
end
