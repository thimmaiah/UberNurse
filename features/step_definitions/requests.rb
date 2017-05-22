Given(/^there is a request "([^"]*)"$/) do |args|
  if(!@care_home)
    steps %Q{
      Given there is a care_home "verified=true" with an admin "first_name=Admin;role=Admin"
    }
  end

  @staffing_request = FactoryGirl.build(:staffing_request)
  key_values(@staffing_request, args)
  @staffing_request.care_home = @care_home
  @staffing_request.user = @care_home.users.admins.first
  @staffing_request.save!
end

Given(/^there are "(\d+)" of verified requests$/) do |count|
  (1..count.to_i).each do |i|
    @staffing_request = FactoryGirl.build(:staffing_request)
    @staffing_request.care_home = @care_home
    @staffing_request.user = @care_home.users.admins.first
    @staffing_request.save!
  end
end

Then(/^I must see all the requests$/) do
  StaffingRequest.all.each do |req|
    expect(page).to have_content(@staffing_request.care_home.name)
    expect(page).to have_content(@staffing_request.rate_per_hour)
    expect(page).to have_content(@staffing_request.request_status)
    expect(page).to have_content(@staffing_request.start_date.in_time_zone("New Delhi").strftime("%d/%m/%Y %H:%M") )
    expect(page).to have_content(@staffing_request.end_date.in_time_zone("New Delhi").strftime("%d/%m/%Y %H:%M") )
  end
end


When(/^I click on the request I must see the request details$/) do
  StaffingRequest.all.each do |req|
    item = "#StaffingRequest-#{req.id}-item"
    page.find(item).click
    @staffing_request = req
    steps %Q{
      Then I must see the request details
    }
    page.find(".back-button").click


  end

end

When(/^I create a new Staffing Request "([^"]*)"$/) do |args|
  @staffing_request = FactoryGirl.build(:staffing_request)
  key_values(@staffing_request, args)
  page.find("#new_staffing_request_btn").click()

  fields = ["rate_per_hour", "auto_deny_in", "start_code", "end_code"]
  fields.each do |k|
    fill_in(k, with: @staffing_request[k])
  end

  fill_in("auto_deny_in", with: @staffing_request.auto_deny_in)

  click_on("Save")
  sleep(2)

end

Then(/^the request must be saved$/) do

  last = StaffingRequest.last

  @staffing_request.rate_per_hour.should == last.rate_per_hour
  @staffing_request.start_code.should == last.start_code
  @staffing_request.end_code.should == last.end_code

  last.user_id.should == @user.id
  last.care_home_id.should == @user.care_home_id
  last.request_status.should == "Open"
  last.payment_status.should == "Unpaid"
  last.broadcast_status.should == "Pending"
end



Then(/^I must see the request details$/) do
  expect(page).to have_content(@staffing_request.care_home.name)
  expect(page).to have_content(@staffing_request.user.first_name)
  expect(page).to have_content(@staffing_request.user.last_name)
  expect(page).to have_content(@staffing_request.rate_per_hour)
  expect(page).to have_content(@staffing_request.request_status)
  expect(page).to have_content(@staffing_request.payment_status)
  expect(page).to have_content(@staffing_request.start_date.in_time_zone("New Delhi").strftime("%d/%m/%Y %H:%M") )
  expect(page).to have_content(@staffing_request.end_date.in_time_zone("New Delhi").strftime("%d/%m/%Y %H:%M") )
  expect(page).to have_content(@staffing_request.start_code)
  expect(page).to have_content(@staffing_request.end_code)
end
