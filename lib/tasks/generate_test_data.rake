namespace :uber_nurse do

  require "faker"
  require 'digest/sha1'
  require 'factory_girl'


  desc "Cleans p DB - DELETES everything -  watch out"
  task :emptyDB => :environment do
    User.delete_all
    CareHome.delete_all
    Delayed::Job.delete_all
    StaffingRequest.delete_all
    Shift.delete_all
    Payment.delete_all
    Rating.delete_all
    PaperTrail::Version.delete_all
    Stat.delete_all
    Agency.delete_all
  end


  desc "generates fake Agencies for testing"
  task :generateFakeAgencies => :environment do
    begin
      (1..1).each do |i|
        FactoryGirl.create(:agency)
      end
    rescue Exception => exception
      puts exception.backtrace.join("\n")
      raise exception
    end
  end  

  desc "generates fake CareHomes for testing"
  task :generateFakeCareHomes => :environment do


    begin


      agency_ids = Agency.all.collect(&:id)
      User::SPECIALITY.each do |sp|
        (1..2).each do | i |
          h = FactoryGirl.build(:care_home)
          h.created_at = Date.today - rand(4).weeks - rand(7).days
          h.speciality = sp
          h.save
          #puts u.to_xml(:include => :care_home_industry_mappings)
          puts "CareHome #{h.id}"
          agency_ids.sample(2).to_set.each do |aid|
            AgencyCareHomeMapping.create(agency_id: aid, care_home_id: h.id)
          end
        end
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

      i = 1
      care_homes.each do |c|
        count = 1
        (0..1).each do |j|
          u = FactoryGirl.build(:user)
          u.email = "admin#{i}@gmail.com"
          u.password = "admin#{i}@gmail.com"
          u.role = "Admin"
          u.care_home_id = c.id
          u.created_at = Date.today - rand(4).weeks - rand(7).days
          u.save!
          #puts u.to_xml
          puts "User #{u.id}"
          AgencyUserMapping.create(agency_id: c.agency_care_home_mappings.sample.id, user_id: u.id)
          i = i + 1
        end
      end

      Agency.all.each do |agency|
          i = 1
          # Now generate some consumers
          User::SPECIALITY.each do |sp|
            (1..4).each do |j|
              u = FactoryGirl.build(:user)        
              u.verified = true
              u.email = "carer#{i}_#{agency.id}@gmail.com"
              u.password = "carer#{i}_#{agency.id}@gmail.com"
              u.role = "Care Giver"
              u.speciality = sp
              u.image_url = images[rand(images.length)]
              u.created_at = Date.today - rand(4).weeks - rand(7).days
              u.save!
              AgencyUserMapping.create(agency_id: agency.id, user_id: u.id)

              p = FactoryGirl.build(:profile)
              p.user = u
              p.agency = agency
              p.role = u.role
              p.known_as = u.first_name
              p.save!
              (1..2).each do |ti|
                t = FactoryGirl.build(:training)
                t.profile = p
                t.user = u
                t.agency = agency
                t.save!
              end
              #puts u.to_xml
              puts "User #{u.id}"
              i = i + 1
            end
          end

          User::SPECIALITY.each do |sp|
            (1..2).each do |j|
              u = FactoryGirl.build(:user)
              u.verified = true
              u.email = "nurse#{i}_#{agency.id}@gmail.com"
              u.password = "nurse#{i}_#{agency.id}@gmail.com"          
              u.role = "Nurse"
              u.speciality = sp
              u.image_url = images[rand(images.length)]
              u.created_at = Date.today - rand(4).weeks - rand(7).days
              u.save!
              AgencyUserMapping.create(agency_id: agency.id, user_id: u.id)
              #puts u.to_xml
              p = FactoryGirl.build(:profile)
              p.agency = agency
              p.user = u
              p.role = u.role
              p.known_as = u.first_name
              p.save!
              
              (1..2).each do |ti|
                t = FactoryGirl.build(:training)
                t.agency = agency
                t.profile = p
                t.user = u
                t.save!
              end
              
              puts "User #{u.id}"
              i = i + 1
            end
          end

        u = FactoryGirl.build(:user)
        u.verified = true        # Ensure User role is USER_ROLE_ID
        u.role = "Agency"      
        u.save
        #puts u.to_xml
        puts "User #{u.id}"
        AgencyUserMapping.create(agency_id: agency.id, user_id: u.id)

      end

      

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
          u.created_at = Date.today - rand(4).weeks - rand(7).days
          u.care_home = c
          u.agency = c.agencies.sample
          u.request_status = rand(10) > 2 ? "Approved" : "Rejected"
          u.user = c.users[0]
          u.created_at = Date.today - rand(4).weeks - rand(7).days
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
          u = FactoryGirl.build(:shift)
          u.staffing_request = req
          u.agency = req.agency
          u.care_home_id = req.care_home_id
          u.user = care_givers[rand(care_givers.length)]
          u.save

          u.response_status =  "Accepted" #rand(2) > 0 ? "Accepted" : "Rejected"
          u.accepted = true
          u.save

          req.broadcast_status = "Sent"
          req.save

          if rand(2) > 0
            u.set_codes_test
            u.reload
            ShiftCloseJob.new.perform(u.id)
          end
          #puts u.to_xml
          puts "Shift #{u.id}"
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

      resps = Shift.accepted

      resps.each do |resp|
        u = FactoryGirl.build(:payment)
        u.shift = resp
        u.agency = resp.agency
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

      resps = Shift.accepted

      resps.each do |resp|
        u = FactoryGirl.build(:rating)
        u.shift = resp
        u.agency = resp.agency
        u.rated_entity = resp.user
        u.created_by_id = resp.staffing_request.user_id
        u.care_home_id = resp.staffing_request.care_home_id
        u.save # Generate payments only for some accepted responses
        #puts u.to_xml
        puts "Rating #{u.id}"

        u = FactoryGirl.build(:rating)
        u.shift = resp
        u.agency = resp.agency
        u.rated_entity = resp.care_home
        u.created_by_id = resp.user_id
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

      Agency.all.each do |agency|
        ["North", "South"].each do |zone|
          ["Nurse", "Care Giver"].each do |role|
            User::SPECIALITY.each do |sp|
              u = FactoryGirl.build(:rate)
              #u.speciality = spec
              u.role = role
              u.zone = zone
              u.agency = agency
              u.speciality = sp
              u.save 
              #puts u.to_xml
              puts "Rate #{u.id}"
            end
          end
        end
      end


    rescue Exception => exception
      puts exception.backtrace.join("\n")
      raise exception
    end
  end

  task :finalize => :environment do
    Delayed::Job.delete_all
    ShiftCreatorJob.add_to_queue
  end

  desc "Generating all Fake Data"
  task :generateFakeAll => [:emptyDB, :generateFakeAgencies, :generateFakeCareHomes, :generateFakeUsers,
  :generateFakeAdmin, :generateFakeReq, :generateFakeResp, 
  :generateFakeRatings, :finalize] do
    puts "Generating all Fake Data"
  end

  task :generateLoadTestData => [:emptyDB, :generateFakeAgencies, :generateFakeCareHomes, :generateFakeUsers, :finalize] do
    puts "Generating all Fake Data"
  end



end
