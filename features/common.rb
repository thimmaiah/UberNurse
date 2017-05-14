Given(/^there is a user "([^"]*)"$/) do |arg1|
  puts  arg1
  @user = FactoryGirl.build(:user)
  key_val = Hash[arg1.split(";").map{|kv| kv.split("=")}]
  key_val.each do |k, v|
    @user[k] = v
  end
  @user.save!
end

Then(/^I should see the "([^"]*)"$/) do |arg1|
  expect(page).to have_content(arg1)
end
