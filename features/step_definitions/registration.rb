Given(/^I am at the registration page$/) do
  visit("/")
  click_on("Register")
end

When(/^I fill and submit the registration page$/) do


  sex = @user.sex == "M" ? "Male" : "Female"
  ionic_select(sex, "sex", true)

  role = @user.role == "Care Giver" ? "Care Giver" : "Care Home Admin"
  ionic_select(role, "role", false)

  fill_in("first_name", with: @user.first_name)
  fields = [	"first_name", "last_name", "email", "phone", "password", "postcode"]
  fields.each do |k|
    fill_in(k, with: @user[k])
  end

  fill_in("password", with: @user.email)

  # select @user.role, :from => "role"
  # select @user.sex, :from => "sex"

  if(@user.role == 'Care Giver')
    fields = [	"languages", "pref_commute_distance", "speciality", "experience", "sort_code",
               "bank_account", "postcode"]
    fields.each do |k|
      fill_in(k, with: @user[k])
    end
  end


  click_on("Save")
end

Then(/^when I click the confirmation link$/) do
  @saved_user = User.last
  visit("http://localhost:3000/auth/confirmation?config=default&confirmation_token=#{@saved_user.confirmation_token}&redirect_url=http://localhost:8100")
end

Then(/^the user should be confirmed$/) do
  @saved_user.reload
  @saved_user.confirmed_at.should_not be_nil


  fields = [	"first_name", "last_name", "email", "phone", "postcode"]
  fields.each do |k|
    expect(@user[k]).to eql(@saved_user[k])
  end


  if(@user.role == 'Care Giver')
    fields = [	"languages", "pref_commute_distance", "speciality", "experience", "sort_code",
               "bank_account", "postcode"]
    fields.each do |k|
      expect(@user[k]).to eql(@saved_user[k])
    end
  end
end
