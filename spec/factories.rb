include ActionDispatch::TestProcess

FactoryGirl.define do
  factory :staffing_response do
    accepted false
    rated false
  end

  factory :staffing_request do
    start_date {Date.today + 1.day}
    end_date {start_date + 8.hours}
    rate_per_hour 15
    request_status {StaffingRequest::REQ_STATUS[rand(StaffingRequest::REQ_STATUS.length)]}
    auto_deny_in 12
    response_count 0
    payment_status {"Unpaid"}
  end

  factory :hospital do
    name {Faker::Company.name}
    address { Faker::Address.street_address }
    town { Faker::Address.city }
    #county { Faker::Address.county }
    street { Faker::Address.street_name }
    postcode { Faker::Address.postcode }
  end

  factory :user do
    ignore do
    end

   # hospital_id { hospital.id if hospital }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    password {email}
    phone {"2125555" + rand(999).to_s.center(3, rand(9).to_s)}
    address { Faker::Address.street_address }
    confirmation_sent_at { Time.now }
    confirmed_at { Time.now }
    sign_in_count { 5 }
    role {"Care Giver"}
    sex { User::SEX[rand(2)]}
    speciality { User::SPECIALITY[rand(User::SPECIALITY.length)]}
    experience { rand(5) + 1}
    accept_terms {true}
    pref_commute_distance {rand(10) + 1 }
    languages {"English"}

    trait :new_user do
      confirmed_at nil
      confirmation_sent_at nil
      sign_in_count nil
    end

    factory :vendor do
      vendor_buyer_flag {"Vendor"}
      user_role_id {  [ADMIN_USER_ROLE_ID,EMPLOYEE_ROLE_ID][rand(2)] }
    end

    factory :employee do
      vendor_buyer_flag {"Vendor"}
      user_role_id {  EMPLOYEE_ROLE_ID }
    end
    
    factory :admin do
      vendor_buyer_flag {"Vendor"}
      user_role_id {  ADMIN_USER_ROLE_ID }
    end

    factory :buyer do
      vendor_buyer_flag {"Buyer"}
      user_role_id { USER_ROLE_ID }
    end

  end

end