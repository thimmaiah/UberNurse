Given(/^the shift creator job runs$/) do
  ShiftCreatorJob.new.perform
  @shift = Shift.last
end


Then(/^A shift must be created for the user for the request$/) do
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

  puts "\n#####Accepted Shift####\n"
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

  puts "\n#####Rejected Shift####\n"
  puts @shift.to_json
end

Then(/^A shift must not be created for the user for the request$/) do
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

Then(/^I must see the shift$/) do
  @shift = Shift.last
  expect(page).to have_content(@shift.care_home.name)
  expect(page).to have_content(@shift.user.first_name)
  expect(page).to have_content(@shift.user.last_name)
  expect(page).to have_content(@shift.staffing_request.start_date.in_time_zone("New Delhi").strftime("%d/%m/%Y %H:%M") )
  expect(page).to have_content(@shift.staffing_request.end_date.in_time_zone("New Delhi").strftime("%d/%m/%Y %H:%M") )
  expect(page).to have_content(@shift.user.phone)
  expect(page).to have_content(@shift.user.email)
  expect(page).to have_content(@shift.user.speciality)
end

When(/^I click the shift for details$/) do
  page.find("#shift-#{@shift.id}-item").click
end


Then(/^I must see the shift details$/) do

  steps %Q{
    Then I must see the shift 
  }

  expect(page).to have_content(@shift.response_status)
  expect(page).to have_content(@shift.payment_status)
  expect(page).to have_content(@shift.start_code) if @shift.start_code
  expect(page).to have_content(@shift.end_code) if @shift.end_code

  page.find(".back-button").click
end


Given(/^there are "([^"]*)" of shifts$/) do |count|
  (1..count.to_i).each do |i|
    steps %Q{
      Given there is a user "role=Care Giver;verified=true"
      Given the user has already accepted a request "role=Care Giver"
    } 
  end
end

Given(/^there are "([^"]*)" of shifts for the care_home$/) do |arg1|
  count = arg1.to_i
  StaffingRequest.all.each do |req|
    @staffing_request = req
    steps %Q{
      Given there is a user "role=Care Giver;verified=true"
      Given the user has already accepted a request "role=Care Giver"
    }
  end
end


Then(/^I must not see the shifts$/) do
  Shift.all.each do |shift|
    expect(page).to have_content("No Shifts Found")
  end
end


Then(/^I must see all the shifts$/) do
  Shift.all.each do |shift|    
    steps %Q{
      Then I must see the shift 
      When I click the shift for details
      Then I must see the shift details
    }
  end
end

Given(/^there is a shift for a user "([^"]*)" with status "([^"]*)"$/) do |arg1, status|
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



Given(/^the shift was created "([^"]*)" before$/) do |arg1|
  @shift.created_at = Time.now - arg1.to_i.minutes
  @shift.save!
end

Given(/^the shift pending job runs$/) do
  clear_emails
  ShiftPendingJob.new.perform()
end

Given(/^the shift confirm job runs$/) do
  clear_emails
  ShiftConfirmJob.new.perform()
end


Then(/^A shift status must be "([^"]*)"$/) do |arg1|
  @shift.reload
  @shift.response_status.should == arg1
end

Given(/^the shift has confirm_sent "([^"]*)" times$/) do |arg1|
  (1..arg1.to_i).each do 
    @shift.confirmation_sent
  end
end

Then(/^when the user enters the start and end code$/) do
  @shift.start_code = @staffing_request.start_code
  @shift.end_code = @staffing_request.end_code
  @shift.save
end

Then(/^the shift price is computed and stored$/) do
  @shift.reload
  @shift.price.should_not be nil
end

Then(/^the payment for the shift is generated$/) do
  @payment = Payment.last
  @payment.shift_id.should == @shift.id
  @payment.amount.should == @shift.price
  @payment.care_home_id.should == @staffing_request.care_home_id
  @payment.user_id.should == @shift.user_id
end

Then(/^the shift is marked as closed$/) do
  @shift.response_status.should == "Closed"
end

Then(/^the request is marked as closed$/) do
  @staffing_request.reload
  @staffing_request.request_status.should == "Closed"
end