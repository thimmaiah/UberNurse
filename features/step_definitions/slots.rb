Given(/^the slot creator job runs$/) do
  SlotCreatorJob.new.perform
end


Then(/^A slot must be created for the user for the request$/) do
  @slot = StaffingResponse.last
  @slot.user_id.should == @user.id
  @slot.staffing_request_id.should == @staffing_request.id
end

Given(/^the user has already accepted this request$/) do
  slot = FactoryGirl.build(:staffing_response)
  slot.user = @user
  slot.staffing_request = @staffing_request
  slot.care_home_id = @staffing_request.care_home_id
  slot.response_status = "Accepted"
  slot.save!

  puts "Created slot"
  puts slot.to_json
end


Given(/^the user has already rejected this request$/) do
  slot = FactoryGirl.build(:staffing_response)
  slot.user = @user
  slot.staffing_request = @staffing_request
  slot.care_home_id = @staffing_request.care_home_id
  slot.response_status = "Rejected"
  slot.save!

  puts "Created slot"
  puts slot.to_json
end

Then(/^A slot must not be created for the user for the request$/) do
  @user.staffing_responses.not_rejected.where(staffing_request_id:@staffing_request.id).length.should == 0
end


Given(/^the user has already accepted a request "([^"]*)"$/) do |arg1|
  steps %Q{
    Given there is a request "#{arg1}"
    And the user has already accepted this request
  }
end


Then(/^the request broadcast status must change to "([^"]*)"$/) do |arg1|
  @staffing_request.reload
  @staffing_request.broadcast_status.should == arg1
end

Then(/^the users auto selected date should be set to today$/) do
  @user.reload
  @user.auto_selected_date.should == Date.today
end

Then(/^I must see the slot$/) do
  @slot = StaffingResponse.last
  expect(page).to have_content(@slot.care_home.name)
  expect(page).to have_content(@slot.user.first_name)
  expect(page).to have_content(@slot.user.last_name)
  expect(page).to have_content(@slot.staffing_request.start_date.in_time_zone("New Delhi").strftime("%d/%m/%Y %H:%M") )
  expect(page).to have_content(@slot.staffing_request.end_date.in_time_zone("New Delhi").strftime("%d/%m/%Y %H:%M") )
  expect(page).to have_content(@slot.user.phone)
  expect(page).to have_content(@slot.user.email)
  expect(page).to have_content(@slot.user.speciality)
end

When(/^I click the slot for details$/) do
  page.find("#slot-#{@slot.id}-item").click
end


Then(/^I must see the slot details$/) do

  steps %Q{
    Then I must see the slot 
  }

  expect(page).to have_content(@slot.response_status)
  expect(page).to have_content(@slot.payment_status)
  expect(page).to have_content(@slot.start_code) if @slot.start_code
  expect(page).to have_content(@slot.end_code) if @slot.end_code

  page.find(".back-button").click
end


Given(/^there are "([^"]*)" of slots$/) do |count|
  (1..count.to_i).each do |i|
    steps %Q{
      Given there is a user "role=Nurse;verified=true"
      Given the user has already accepted this request
    } 
  end
end

Given(/^there are "([^"]*)" of slots for the care_home$/) do |arg1|
  count = arg1.to_i
  StaffingRequest.all.each do |req|
    @staffing_request = req
    steps %Q{
      Given there is a user "role=Nurse;verified=true"
      Given the user has already accepted this request
    }
  end
end


Then(/^I must not see the slots$/) do
  StaffingResponse.all.each do |slot|
    expect(page).to have_content("No Slots Booked")
  end
end


Then(/^I must see all the slots$/) do
  StaffingResponse.all.each do |slot|    
    steps %Q{
      Then I must see the slot 
      When I click the slot for details
      Then I must see the slot details
    }
  end
end
