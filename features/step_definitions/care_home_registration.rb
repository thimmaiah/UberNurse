Given(/^I am at the care homes registration page$/) do
  click_on("Register Care Home")
end

When(/^I fill and submit the care homes registration page with "([^"]*)"$/) do |arg1|
  @care_home = FactoryGirl.build(:care_home)
  fields = ["name", "address", "town", "postcode", "base_rate", "image_url"]
  fields.each do |k|
    fill_in(k, with: @care_home[k])
    sleep(0.5)
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
