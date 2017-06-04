Given(/^a unsaved request "([^"]*)"$/) do |args|
  
  puts "####creating and unsaved request from args #{args}\n"

  if(!@care_home)
    steps %Q{
      Given there is a care_home "verified=true" with an admin "first_name=Admin;role=Admin"
    }
  end

  @staffing_request = FactoryGirl.build(:staffing_request)
  key_values(@staffing_request, args)
  @staffing_request.care_home = @care_home
  @staffing_request.user = @care_home.users.admins.first
end

Given(/^there is a request "([^"]*)"$/) do |args|
  if(!@care_home)
    steps %Q{
      Given there is a care_home "verified=true" with an admin "first_name=Admin;role=Admin"
    }
  end
  steps %Q{
    Given a unsaved request "#{args}"
  }

  @staffing_request.save!
  puts "\n#####StaffingRequest####\n" 
  puts @staffing_request.to_json
end

Given(/^there is a request "([^"]*)" with start date atleast "([^"]*)" from now and end date atleast "([^"]*)" from now$/) do |arg1, arg2, arg3|
  steps %Q{
      Given there is a care_home "verified=true" with an admin "first_name=Admin;role=Admin"
      Given a unsaved request "#{arg1}"
  }

  @staffing_request.start_date = Time.now.at_beginning_of_day + arg2.to_f.days
  while(@staffing_request.start_date.on_weekend?)
    @staffing_request.start_date = @staffing_request.start_date + 1.day
  end

  @staffing_request.end_date = Time.now.at_beginning_of_day + arg3.to_f.days
  while(@staffing_request.end_date.on_weekend?)
    @staffing_request.end_date = @staffing_request.end_date + 1.day
  end

  @staffing_request.save!
  puts "\n#####StaffingRequest####\n" 
  puts @staffing_request.to_json
end

Given(/^there is a request "([^"]*)" on a weekend for "([^"]*)"$/) do |arg1, arg2|
  steps %Q{
      Given there is a care_home "verified=true" with an admin "first_name=Admin;role=Admin"
      Given a unsaved request "#{arg1}"
  }

  @staffing_request.start_date = Time.now.at_end_of_week
  @staffing_request.end_date = Time.now.at_end_of_week + arg2.to_f.hours
  @staffing_request.save!

  puts "\n#####StaffingRequest####\n" 
  puts @staffing_request.to_json
end

Given(/^there is a request "([^"]*)" "([^"]*)" from now$/) do |arg1, arg2|
  steps %Q{
      Given there is a care_home "verified=true" with an admin "first_name=Admin;role=Admin"
      Given a unsaved request "#{arg1}"
  }

  @staffing_request.start_date = Time.now + arg2.to_f.hours
  @staffing_request.end_date = @staffing_request.start_date + 10.hours
  @staffing_request.save!
  
  puts "\n#####StaffingRequest####\n" 
  puts @staffing_request.to_json

end

Given(/^there is a request "([^"]*)" on a bank holiday$/) do |arg1|
  d = Date.today + 1.day
  Holiday.create(name: "Test Holiday", date: d, bank_holiday: true)

  steps %Q{
      Given there is a care_home "verified=true" with an admin "first_name=Admin;role=Admin"
      Given a unsaved request "#{arg1}"
  }

  @staffing_request.start_date = Time.now.at_beginning_of_day + 1.day
  @staffing_request.end_date = Time.now.at_beginning_of_day + 1.days + 10.hours
  @staffing_request.save!
  
  puts "\n#####StaffingRequest####\n" 
  puts @staffing_request.to_json
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

  ionic_select(@staffing_request.role, "role", true)
  ionic_select(@staffing_request.speciality, "speciality", false)

  fields = ["start_code", "end_code"]
  fields.each do |k|
    fill_in(k, with: @staffing_request[k])
  end


  click_on("Save")
  sleep(1)

end

Then(/^the request must be saved$/) do

  last = StaffingRequest.last

  @staffing_request.start_code.should == last.start_code
  @staffing_request.end_code.should == last.end_code
  @staffing_request.role.should == last.role
  @staffing_request.speciality.should == last.speciality

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
  expect(page).to have_content(@staffing_request.role)
  expect(page).to have_content(@staffing_request.speciality)
  expect(page).to have_content(@staffing_request.request_status)
  expect(page).to have_content(@staffing_request.payment_status)
  expect(page).to have_content(@staffing_request.start_date.in_time_zone("New Delhi").strftime("%d/%m/%Y %H:%M") )
  expect(page).to have_content(@staffing_request.end_date.in_time_zone("New Delhi").strftime("%d/%m/%Y %H:%M") )
  expect(page).to have_content(@staffing_request.start_code)
  expect(page).to have_content(@staffing_request.end_code)
end


Then(/^the price for the Staffing Request must be "([^"]*)"$/) do |price|
  Rate.price_estimate(@staffing_request).should == price.to_f
end


Given(/^the rate is "([^"]*)"$/) do |arg1|
  Rate.where(zone:@staffing_request.care_home.zone,
             role:@staffing_request.role,
             speciality: @staffing_request.speciality).update(amount: arg1.to_f)
end


Given(/^the request start_date is "([^"]*)" from now$/) do |arg1|
  @staffing_request.start_date = Time.now + eval(arg1)
  @staffing_request.end_date = Time.now + eval(arg1) + 8.hours
  @staffing_request.save!
end
