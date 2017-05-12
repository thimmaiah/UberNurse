include ActionDispatch::TestProcess

FactoryGirl.define do
  
  factory :rating do
    stars {rand(4) + 1}
    comments {Rating::COMMENTS[rand(Rating::COMMENTS.length)]}
  end

  factory :payment do
    staffing_response_id 1
    user_id 1
    hospital_id 1
    paid_by_id 1
    amount 100
    notes "Thanks for your service"
  end

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
    postcode { PostCode.offset(rand(PostCode.count)).first.postcode }
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
    postcode { PostCode.offset(rand(PostCode.count)).first.postcode }
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
    verified {rand(2) > 0 ? true : false}
    
    trait :new_user do
      confirmed_at nil
      confirmation_sent_at nil
      sign_in_count nil
    end

    
  end

end