include ActionDispatch::TestProcess

FactoryGirl.define do
  factory :referral do
    first_name "MyString"
    last_name "MyString"
    email "MyString"
    role "MyString"
    user_id 1
  end
  factory :holiday do
    name "MyString"
    date "2017-05-23"
    bank_holiday false
  end


  factory :rate do
    zone "North"
    role "Care Giver"
    carer_weekday 9
    care_home_weekday 11
    carer_weeknight 11
    care_home_weeknight 14
    carer_weekend 11
    care_home_weekend 13
    carer_weekend_night 12
    care_home_weekend_night 15
    carer_bank_holiday 14
    care_home_bank_holiday 20    
  end

  factory :rating do
    stars {rand(4) + 1}
    comments {Rating::COMMENTS[rand(Rating::COMMENTS.length)]}
  end

  factory :payment do
    shift_id 1
    user_id 1
    care_home_id 1
    paid_by_id 1
    amount 100
    notes "Thanks for your service"
  end

  factory :shift do
    accepted false
    rated false
  end

  factory :staffing_request do
    start_date {Date.today + 1.day + 2.hours}
    end_date {start_date + 8.hours}
    rate_per_hour 15
    request_status {"Open"}
    auto_deny_in 12
    response_count 0
    role {["Nurse", "Care Giver"][rand(2)]}
    payment_status {"Unpaid"}
    start_code {rand.to_s[2..6]}
    end_code {rand.to_s[2..6]}
    created_at {Time.now - 1.day}
    updated_at {Time.now - 1.day}
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
    phone {"2125555" + rand(999).to_s.center(3, rand(9).to_s)}
    image_url {logos[rand(logos.length)]}
    address {Faker::Address.street_address}
    postcodelatlng { PostCode.where("length(postcode)=6").offset(rand(PostCode.where("length(postcode)=6").count)).first }
    zone {CareHome::ZONES[rand(CareHome::ZONES.length)]}
    bank_account {rand.to_s[2..9]} 
    sort_code {rand.to_s[2..7]} 
    verified {true}
  end

  factory :user do
    ignore do
    end

    # care_home_id { care_home.id if care_home }
    title {User::TITLE[rand(User::TITLE.length-1) + 1]}
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    password {email}
    phone {"2125555" + rand(999).to_s.center(3, rand(9).to_s)}
    address { Faker::Address.street_address }
    postcodelatlng { PostCode.where("length(postcode)=6").offset(rand(PostCode.where("length(postcode)=6").count)).first }
    #postcodelatlng { PostCode.offset(rand(PostCode.count)).first }
    confirmation_sent_at { Time.now }
    confirmed_at { Time.now }
    sign_in_count { 5 }
    role {"Care Giver"}
    sex { User::SEX[rand(2)]}
    accept_terms {true}
    pref_commute_distance {[10,15,20,25,100].sample}
    verified {rand(2) > 0 ? true : false}
    phone_verified {true}

    bank_account {rand.to_s[2..9] if(role != "Admin")}
    sort_code {rand.to_s[2..7] if(role != "Admin")}


    trait :new_user do
      confirmed_at nil
      confirmation_sent_at nil
      sign_in_count nil
    end


  end

end
