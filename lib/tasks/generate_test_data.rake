namespace :uber_nurse do    
  
  require "faker"
  require 'digest/sha1'  
  require 'factory_girl'  
  # require File.expand_path("spec/factories.rb")
  # require File.expand_path("spec/factories/entities.rb")
  
  desc "generates Config Files" 
  task :generateConfigs => :environment do
    
      puts "Rails.root = #{Rails.root}"
  	  bindings_file = 	"#{Rails.root}" + '/config/deploy_templates/bindings.rb'
  	  template_dir = 	"#{Rails.root}" + "/config/deploy_templates"
  	  release_path =	"#{Rails.root}"
  	  true_production = false
  	  host = 			"localhost"
  	  
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
  	Hospital.delete_all
  	Delayed::Job.delete_all
    StaffingRequest.delete_all
    StaffingResponse.delete_all
    Payment.delete_all
  end
  
  
  
  desc "generates fake Hospitals for testing" 
  task :generateFakehospitals => :environment do
    
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
    
    begin    
        
          (1..10).each do | i |
            h = FactoryGirl.build(:hospital) 
            h.image_url = logos[rand(logos.length)]
            h.save
            #puts u.to_xml(:include => :hospital_industry_mappings)
            puts "Hospital #{h.id}"  
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
      
		hospitals = Hospital.all
		
		hospitals.each do |c|
				count = rand(3) + 1
		   		(1..count).each do |j|    
			        u = FactoryGirl.build(:user)
			        if(rand(2) > 0)
	            		u.role = "Employee"
	            	else
	            		u.role = "Admin"
	            	end
			        u.hospital_id = c.id				               
			        u.save
				    #puts u.to_xml
				    puts "User #{u.id}"              
		      	end	
		end	  
    
    # Now generate some consumers
    (1..20).each do |j|    
      u = FactoryGirl.build(:user)
      # Ensure User role is USER_ROLE_ID
      u.role = "Care Giver"        
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
    u.hospital = Hospital.first        
    u.save
    #puts u.to_xml
    puts "User #{u.id}"  

    u = FactoryGirl.build(:user)
    u.email = "admin@ubernurse.com"
    u.password = u.email
    u.role = "Admin"
    u.hospital = Hospital.first        
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
      
      hospitals = Hospital.all
    
      hospitals.each do |c|
          count = rand(5) + 3
            (1..count).each do |j|    
                u = FactoryGirl.build(:staffing_request)
                u.hospital = c
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
      
      reqs = StaffingRequest.approved
      care_givers = User.care_givers.sort_by { rand }
    
      reqs.each do |req|
          count = 1
            (1..count).each do |j|    
                u = FactoryGirl.build(:staffing_response)
                u.staffing_request = req
                u.hospital_id = req.hospital_id
                u.user = care_givers[j]                       
                u.response_status =  "Accepted" #rand(2) > 0 ? "Accepted" : "Rejected"
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
          u.hospital_id = resp.hospital_id
          u.user_id = resp.user_id                       
          u.paid_by_id = resp.hospital.users.first
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
  
  
  desc "Generating all Fake Data"
  task :generateFakeAll => [:emptyDB, :generateFakehospitals, :generateFakeUsers, 
    :generateFakeAdmin, :generateFakeReq, :generateFakeResp, :generateFakePayments] do
    puts "Generating all Fake Data"
  end	
	
	
 	
end