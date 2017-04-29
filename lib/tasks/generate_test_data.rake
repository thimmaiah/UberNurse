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
  end
  
  
  desc "generates Affiliates" 
  task :generateAffiliates => :environment do
  	FactoryGirl.create(:affiliate, {name: "GNYCC", url: "http://www.ny-chamber.com/", logo: "GNYCC.gif"})
  	FactoryGirl.create(:affiliate,{name: "MCC", url: "http://www.manhattancc.org", logo: "MCC.jpg"})
  	FactoryGirl.create(:affiliate,{name: "GVCCC", url: "www.villagechelsea.com/", logo: "GVCCC.png"})
  	FactoryGirl.create(:affiliate,{name: "BCC", url: "www.bronxchamber.com/", logo: "bronx_cc.png"})
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
          count = rand(3) + 1
            (1..count).each do |j|    
                u = FactoryGirl.build(:staffing_request)
                u.hospital = c
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
      
      reqs = StaffingRequest.all
      care_givers = User.care_givers.sort_by { rand }
    
      reqs.each do |req|
          count = rand(3) + 1
            (1..count).each do |j|    
                u = FactoryGirl.build(:staffing_response)
                u.staffing_request = req
                u.user = care_givers[j]                       
                u.save
              #puts u.to_xml
              puts "StaffingResponse #{u.id}"              
              end 
      end  

    rescue Exception => exception
      puts exception.backtrace.join("\n")
      raise exception
    end
  end 
  
  
  desc "Generating all Fake Data"
  task :generateFakeAll => [:emptyDB, :generateFakehospitals, :generateFakeUsers, 
    :generateFakeAdmin, :generateFakeReq, :generateFakeResp] do
    puts "Generating all Fake Data"
  end	
	
	
 	
end