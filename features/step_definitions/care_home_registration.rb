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
