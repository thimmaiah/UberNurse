Given("there is an agency {string}") do |string|
  @agency = FactoryGirl.create(:agency)
  key_values(@agency, string)
end

When("the agency adds the user to its network") do
  aum = AgencyUserMapping.create(user_id: @user.id, agency_id: @agency.id, verified: false, accepted: false)
  aum.save!
end


When("the agency adds the care home to its network") do
  acm = AgencyCareHomeMapping.create(care_home_id: @care_home.id, agency_id: @agency.id, verified: false, accepted: false)
  acm.save!
end

Then("the care home receives an email with {string} in the subject") do |subject|
  open_email(@care_home.users.first.email)
  expect(current_email.subject).to include subject
end
