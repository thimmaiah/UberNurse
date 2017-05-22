include ActionDispatch::TestProcess

FactoryGirl.define do

  factory :rating do
    stars {rand(4) + 1}
    comments {Rating::COMMENTS[rand(Rating::COMMENTS.length)]}
  end

  factory :payment do
    staffing_response_id 1
    user_id 1
    care_home_id 1
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
    request_status {"Open"}
    auto_deny_in 12
    response_count 0
    payment_status {"Unpaid"}
    start_code {rand.to_s[2..6]}
    end_code {rand.to_s[2..6]}
  end

  factory :care_home do

        logos = ["http://www.brandsoftheworld.com/sites/default/files/082010/logo_CCNNNA.png", 
        "http://www.brandsoftheworld.com/sites/default/files/082010/RP.png", 
        "http://www.brandsoftheworld.com/sites/default/files/082010/Immagine_1.png",
        "http://www.brandsoftheworld.com/sites/default/files/082010/shine.png",
        "http://www.brandsoftheworld.com/sites/default/files/082010/MamosZurnalas_logo.png",
        "http://www.brandsoftheworld.com/sites/default/files/082010/Untitled-1_18.gif",
        "http://www.brandsoftheworld.com/sites/default/files/082010/iron_man_2_2.png",
        "http://www.brandsoftheworld.com/sites/default/files/082010/saojoaodabarra.png",
        "http://www.brandsoftheworld.com/sites/default/files/082010/logo_the_avengers.png",
        "http://www.brandsoftheworld.com/sites/default/files/082010/crystal_shopping.png",
        "http://www.brandsoftheworld.com/sites/default/files/082010/Logo_para_crmall.png"]

    name {Faker::Company.name}
    base_rate {15}
    image_url {logos[rand(logos.length)]}
    address {Faker::Address.street_address}
    town {Faker::Address.city}
    postcode { PostCode.offset(rand(PostCode.count)).first.postcode }
  end

  factory :user do
    ignore do
    end

    # care_home_id { care_home.id if care_home }
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


    bank_account {rand.to_s[2..9] if(role != "Admin")}
    sort_code {rand.to_s[2..7] if(role != "Admin")}


    trait :new_user do
      confirmed_at nil
      confirmation_sent_at nil
      sign_in_count nil
    end


  end

end
