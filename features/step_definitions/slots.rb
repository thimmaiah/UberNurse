Given(/^the slot creator job runs$/) do
  SlotCreatorJob.new.perform
  @shift = Shift.last
end


Then(/^A slot must be created for the user for the request$/) do
  @shift = Shift.last
  @shift.user_id.should == @user.id
  @shift.staffing_request_id.should == @staffing_request.id  
end

Given(/^the user has already accepted this request$/) do
  @shift = FactoryGirl.build(:shift)
  @shift.user = @user
  @shift.staffing_request = @staffing_request
  @shift.care_home_id = @staffing_request.care_home_id
  @shift.save

  @shift.response_status = "Accepted"
  @shift.save!

  puts "\n#####Accepted Slot####\n"
  puts @shift.to_json
end


Given(/^the user has already rejected this request$/) do
  @shift = FactoryGirl.build(:shift)
  @shift.user = @user
  @shift.staffing_request = @staffing_request
  @shift.care_home_id = @staffing_request.care_home_id
  @shift.save

  @shift.response_status = "Rejected"
  @shift.save!

  puts "\n#####Rejected Slot####\n"
  puts @shift.to_json
end

Then(/^A slot must not be created for the user for the request$/) do
  @user.shifts.not_rejected.where(staffing_request_id:@staffing_request.id).length.should == 0
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
  @slot = Shift.last
  expect(page).to have_content(@shift.care_home.name)
  expect(page).to have_content(@shift.user.first_name)
  expect(page).to have_content(@shift.user.last_name)
  expect(page).to have_content(@shift.staffing_request.start_date.in_time_zone("New Delhi").strftime("%d/%m/%Y %H:%M") )
  expect(page).to have_content(@shift.staffing_request.end_date.in_time_zone("New Delhi").strftime("%d/%m/%Y %H:%M") )
  expect(page).to have_content(@shift.user.phone)
  expect(page).to have_content(@shift.user.email)
  expect(page).to have_content(@shift.user.speciality)
end

When(/^I click the slot for details$/) do
  page.find("#slot-#{@shift.id}-item").click
end


Then(/^I must see the slot details$/) do

  steps %Q{
    Then I must see the slot 
  }

  expect(page).to have_content(@shift.response_status)
  expect(page).to have_content(@shift.payment_status)
  expect(page).to have_content(@shift.start_code) if @shift.start_code
  expect(page).to have_content(@shift.end_code) if @shift.end_code

  page.find(".back-button").click
end


Given(/^there are "([^"]*)" of slots$/) do |count|
  (1..count.to_i).each do |i|
    steps %Q{
      Given there is a user "role=Care Giver;verified=true"
      Given the user has already accepted a request "role=Care Giver"
    } 
  end
end

Given(/^there are "([^"]*)" of slots for the care_home$/) do |arg1|
  count = arg1.to_i
  StaffingRequest.all.each do |req|
    @staffing_request = req
    steps %Q{
      Given there is a user "role=Care Giver;verified=true"
      Given the user has already accepted a request "role=Care Giver"
    }
  end
end


Then(/^I must not see the slots$/) do
  Shift.all.each do |slot|
    expect(page).to have_content("No Shifts Found")
  end
end


Then(/^I must see all the slots$/) do
  Shift.all.each do |slot|    
    steps %Q{
      Then I must see the slot 
      When I click the slot for details
      Then I must see the slot details
    }
  end
end

Given(/^there is a slot for a user "([^"]*)" with status "([^"]*)"$/) do |arg1, status|
  steps %Q{
    Given there is a request "#{arg1}"
    Given there is a user "#{arg1}"
  }

  @shift = Shift.new(staffing_request_id: @staffing_request.id,
    care_home_id: @staffing_request.care_home_id,
    user_id: @user.id,
    response_status: "Pending")

  @shift.save

  @shift.response_status = status
  @shift.save!
end



Given(/^the slot was created "([^"]*)" before$/) do |arg1|
  @shift.created_at = Time.now - arg1.to_i.minutes
  @shift.save!
end

Given(/^the slot pending job runs$/) do
  clear_emails
  SlotPendingJob.new.perform()
end

Given(/^the slot confirm job runs$/) do
  clear_emails
  SlotConfirmJob.new.perform()
end


Then(/^A slot status must be "([^"]*)"$/) do |arg1|
  @shift.reload
  @shift.response_status.should == arg1
end

Given(/^the slot has confirm_sent "([^"]*)" times$/) do |arg1|
  (1..arg1.to_i).each do 
    @shift.confirmation_sent
  end
end

