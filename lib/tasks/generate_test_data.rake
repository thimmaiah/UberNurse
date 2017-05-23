namespace :uber_nurse do

  require "faker"
  require 'digest/sha1'
  require 'factory_girl'
  # require File.expand_path("spec/factories.rb")
  # require File.expand_path("spec/factories/entities.rb")

  desc "generates Config Files"
  task :generateConfigs => :environment do

    puts "Rails.root = #{Rails.root}"
    bindings_file =   "#{Rails.root}" + '/config/deploy_templates/bindings.rb'
    template_dir =  "#{Rails.root}" + "/config/deploy_templates"
    release_path =  "#{Rails.root}"
    true_production = false
    host =      "localhost"

    puts ""
    puts "##############################"
    puts "##### Generating configs #####"
    puts "Using bindings file #{bindings_file} to generate configs"
    puts "##############################"
    puts ""
    puts File.open("#{bindings_file}").read()
    puts ""
    puts "##############################"
    puts "##############################"

    load( "#{bindings_file}" );

    config_map = {"application.rb"=>"config",
                  "database.yml"=>"config",
                  "01_env.rb"=>"config/initializers",
                  "amazon_ses.rb"=>"config/initializers",
                  "activemerchant.rb"=>"config/initializers",
                  "twilio.rb"=>"config/initializers",
                  "paperclip_interpolates.rb"=>"config/initializers"}

    config_map.each do |config_name, config_dir|
      erb=ERB.new(File.open("#{template_dir}/#{config_name}.erb").read());
      code=erb.result(binding);
      aFile = File.new("#{release_path}/#{config_dir}/#{config_name}", "w")
      aFile.write(code)
      aFile.close
    end

  end


  desc "Cleans p DB - DELETES everything -  watch out"
  task :emptyDB => :environment do
    User.delete_all
    CareHome.delete_all
    Delayed::Job.delete_all
    StaffingRequest.delete_all
    StaffingResponse.delete_all
    Payment.delete_all
    Rating.delete_all
    PaperTrail::Version.delete_all
  end



  desc "generates fake CareHomes for testing"
  task :generateFakecare_homes => :environment do


    begin

      (1..10).each do | i |
        h = FactoryGirl.build(:care_home)
        h.save
        #puts u.to_xml(:include => :care_home_industry_mappings)
        puts "CareHome #{h.id}"
      end

    rescue Exception => exception
      puts exception.backtrace.join("\n")
      raise exception
    end

  end



  desc "generates fake users for testing"
  task :generateFakeUsers => :environment do

    images = ["http://cdn2.hubspot.net/hub/494551/file-2603676543-jpg/jacksonnursing/images/top-quality-rns.jpg",
              "http://globe-views.com/dcim/dreams/nurse/nurse-06.jpg",
              "http://i01.i.aliimg.com/wsphoto/v0/1897854059_1/Free-Shipping-Dentist-Medical-Workwear-Clothes-Doctor-Medical-Gowns-Medical-font-b-Coat-b-font-Medical.jpg",
              "http://www.pngall.com/wp-content/uploads/2016/06/Nurse-PNG-Picture.png",
              "http://s23.postimg.org/54ctzeumj/nurse_22.png",
              "https://www.colourbox.com/preview/2703293-nurse-or-doctor-stands-confidently-with-arms-crossed-on-a-white-background.jpg",
              "http://www.greysrecruitment.co.uk/wp-content/uploads/2015/02/nurse-1.png",
              "http://howtobecomeanurse.yolasite.com/resources/male-nurse1.jpg"]
    begin

      care_homes = CareHome.all

      care_homes.each do |c|
        count = 1
        (0..1).each do |j|
          u = FactoryGirl.build(:user)

          u.role = "Admin"
          u.care_home_id = c.id
          u.save
          #puts u.to_xml
          puts "User #{u.id}"
        end
      end

      # Now generate some consumers
      (1..10).each do |j|
        u = FactoryGirl.build(:user)
        # Ensure User role is USER_ROLE_ID
        u.role = "Care Giver"
        u.image_url = images[rand(images.length)]
        u.save
        #puts u.to_xml
        puts "User #{u.id}"
      end

      (1..10).each do |j|
        u = FactoryGirl.build(:user)
        # Ensure User role is USER_ROLE_ID
        u.role = "Nurse"
        u.image_url = images[rand(images.length)]
        u.save
        #puts u.to_xml
        puts "User #{u.id}"
      end

      u = FactoryGirl.build(:user)
      u.email = "thimmaiah@gmail.com"
      u.password = u.email
      u.first_name="Mohith"
      u.last_name="Thimmaiah"
      # Ensure User role is USER_ROLE_ID
      u.role = "Care Giver"
      u.save
      #puts u.to_xml
      puts "User #{u.id}"

      u = FactoryGirl.build(:user)
      u.email = "employee@ubernurse.com"
      u.password = u.email
      u.role = "Employee"
      u.care_home = CareHome.first
      u.save
      #puts u.to_xml
      puts "User #{u.id}"

      u = FactoryGirl.build(:user)
      u.email = "admin@ubernurse.com"
      u.password = u.email
      u.role = "Admin"
      u.care_home = CareHome.first
      u.save
      #puts u.to_xml
      puts "User #{u.id}"

      u = FactoryGirl.build(:user)
      u.email = "root@ubernurse.com"
      u.password = u.email
      u.role = "Super User"
      u.save
      #puts u.to_xml
      puts "User #{u.id}"


    rescue Exception => exception
      puts exception.backtrace.join("\n")
      raise exception
    end

  end

  desc "generates fake users for testing"
  task :generateFakeAdmin => :environment do

    begin

      u = FactoryGirl.build(:user, email: "admin@ubernurse.com", password: "admin@ubernurse.com", role: "Super User")
      u.save


    rescue Exception => exception
      puts exception.backtrace.join("\n")
      raise exception
    end

  end

  desc "generates fake req for testing"
  task :generateFakeReq => :environment do

    begin

      care_homes = CareHome.all

      care_homes.each do |c|
        count = rand(3) + 1
        (1..count).each do |j|
          u = FactoryGirl.build(:staffing_request)
          u.care_home = c
          u.request_status = rand(10) > 2 ? "Approved" : "Rejected"
          u.user = c.users[0]
          u.save
          #puts u.to_xml
          puts "StaffingRequest #{u.id}"
        end
      end

    rescue Exception => exception
      puts exception.backtrace.join("\n")
      raise exception
    end

  end

  desc "generates fake responses for testing"
  task :generateFakeResp => :environment do

    begin

      reqs = StaffingRequest.open
      care_givers = User.temps.sort_by { rand }

      reqs.each do |req|
        count = 1
        (1..count).each do |j|
          u = FactoryGirl.build(:staffing_response)
          u.staffing_request = req
          u.care_home_id = req.care_home_id
          u.user = care_givers[rand(care_givers.length)]
          u.response_status =  "Accepted" #rand(2) > 0 ? "Accepted" : "Rejected"
          u.accepted = true
          u.save

          req.broadcast_status = "Sent"
          req.save
          #puts u.to_xml
          puts "StaffingResponse #{u.id}"
        end
      end

    rescue Exception => exception
      puts exception.backtrace.join("\n")
      raise exception
    end
  end


  desc "generates fake responses for testing"
  task :generateFakePayments => :environment do

    begin

      resps = StaffingResponse.accepted

      resps.each do |resp|
        u = FactoryGirl.build(:payment)
        u.staffing_response = resp
        u.staffing_request_id = resp.staffing_request_id
        u.care_home_id = resp.care_home_id
        u.user_id = resp.user_id
        u.paid_by_id = resp.care_home.users.first
        if rand(2) > 0
          u.save # Generate payments only for some accepted responses
        end
        #puts u.to_xml
        puts "Payment #{u.id}"
      end


    rescue Exception => exception
      puts exception.backtrace.join("\n")
      raise exception
    end
  end


  desc "generates fake ratings for testing"
  task :generateFakeRatings => :environment do

    begin

      resps = StaffingResponse.accepted

      resps.each do |resp|
        u = FactoryGirl.build(:rating)
        u.staffing_response = resp
        u.user_id = resp.user_id
        u.created_by_id = resp.staffing_request.user_id
        u.care_home_id = resp.staffing_request.care_home_id
        u.save # Generate payments only for some accepted responses
        #puts u.to_xml
        puts "Rating #{u.id}"
      end


    rescue Exception => exception
      puts exception.backtrace.join("\n")
      raise exception
    end
  end

  desc "generates fake rates for testing"
  task :generateFakeRates => :environment do

    begin

      ["North", "South"].each do |zone|
        ["Nurse", "Care Giver"].each do |role|
          User::SPECIALITY.each do |spec|
            u = FactoryGirl.build(:rate)
            u.speciality = spec
            u.role = role
            u.zone = zone
            u.amount = 10 + rand(5)
            u.save # Generate payments only for some accepted responses
            #puts u.to_xml
            puts "Rate #{u.id}"
          end
        end
      end


    rescue Exception => exception
      puts exception.backtrace.join("\n")
      raise exception
    end
  end


  desc "Generating all Fake Data"
  task :generateFakeAll => [:emptyDB, :generateFakecare_homes, :generateFakeUsers,
  :generateFakeAdmin, :generateFakeReq, :generateFakeResp, :generateFakePayments, :generateFakeRatings] do
    puts "Generating all Fake Data"
  end



end
