Given(/^I am at the care homes registration page$/) do
  #click_on("Register Care Home")
end

When(/^I fill and submit the care homes registration page with  "([^"]*)"$/) do |arg1|
  @care_home = FactoryGirl.build(:care_home)
  fields = ["name", "address", "postcode", "image_url"]
  fields.each do |k|
    fill_in(k, with: @care_home[k])
    sleep(1)
  end
  click_on("Save")
end


Then(/^the care home should be created$/) do
  last = CareHome.last
  last.name.should == @care_home.name
  last.postcode.should == @care_home.postcode
  last.base_rate.should == @care_home.base_rate
  last.image_url.should == @care_home.image_url  
end

Then(/^the care home should be unverified$/) do
  last = CareHome.last
  last.verified.should == false
end

Then(/^I should be associated with the care home$/) do
  @user.reload
  @user.care_home_id.should == CareHome.last.id
end

When(/^I search for the care home "([^"]*)"$/) do |arg1|
  @care_home = FactoryGirl.build(:care_home)
  key_values(@care_home, arg1)
  page.find(".searchbar-input").set(@care_home.name)
  sleep(2)
end

When(/^I click on the search result care home$/) do
  within('.list') do
    first('.item').click
  end
  sleep(0.5)
end

When(/^When and submit the care homes registration page with "([^"]*)"$/) do |arg1|
  click_on("Save")
end
