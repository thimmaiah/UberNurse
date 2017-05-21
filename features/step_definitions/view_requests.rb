
Given(/^there are "(\d+)" of verified requests$/) do |count|
  (1..count.to_i).each do |i|
  	@staffing_request = FactoryGirl.build(:staffing_request)
  	@staffing_request.hospital = @hospital
  	@staffing_request.user = @hospital.users.admins.first
  	@staffing_request.save!
  end
end

Then(/^I must see all the requests$/) do
  StaffingRequest.all.each do |req|
  	expect(page).to have_content(req.hospital.name)
  	expect(page).to have_content(req.rate_per_hour)
  	expect(page).to have_content(req.request_status)
  	expect(page).to have_content(req.start_date.in_time_zone("New Delhi").strftime("%d/%m/%Y %H:%M") )
  	expect(page).to have_content(req.end_date.in_time_zone("New Delhi").strftime("%d/%m/%Y %H:%M") )  	
  end
end


When(/^I click on the request I must see the request details$/) do
  StaffingRequest.all.each do |req|
  	item = "#StaffingRequest-#{req.id}-item"
  	puts "Clicking on #{item}"
  	page.find(item).click
  	
  	expect(page).to have_content(req.hospital.name)
  	expect(page).to have_content(req.user.first_name)
  	expect(page).to have_content(req.user.last_name)
    expect(page).to have_content(req.rate_per_hour)
  	expect(page).to have_content(req.request_status)
  	expect(page).to have_content(req.payment_status)
  	expect(page).to have_content(req.start_date.in_time_zone("New Delhi").strftime("%d/%m/%Y %H:%M") )
  	expect(page).to have_content(req.end_date.in_time_zone("New Delhi").strftime("%d/%m/%Y %H:%M") )  	
  	expect(page).to have_content(req.start_code) if req.start_code
  	expect(page).to have_content(req.end_code) if req.end_code

  	page.find(".back-button").click
  	

  end
end

