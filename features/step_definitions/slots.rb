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
  slot.response_status = "Accepted"
  slot.save 
end


Given(/^the user has already rejected this request$/) do
  slot = FactoryGirl.build(:staffing_response)
  slot.user = @user
  slot.staffing_request = @staffing_request
  slot.response_status = "Rejected"
  slot.save 
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
