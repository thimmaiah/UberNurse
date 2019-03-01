namespace :uber_nurse do

  desc "Adds a new agency Connuct"
  task :addNewAgency => :environment do
  	a = Agency.create(name: "Connuct", broadcast_group: "admin@connuct.co.uk", postcode: "AB10 1XG", phone: "999999999", icon_url: "http://qa.connuct.co.uk/wp-content/uploads/2018/04/cropped-icon.png")
  	puts "Create agency #{a.id}"
  	
  	u = User.create(title: "Miss", first_name: "Naomi", last_name: "Connuct", email: "naomi@connuct.co.uk", password: "naomi@connuct.co.uk",
  	role: "Agency", phone: "999999999", postcode: PostCode.first.postcode, confirmation_sent_at: Time.now, confirmed_at: Time.now,
  	sex: "F", accept_terms: true, phone_verified: true, agency_id: a.id )
  	puts "Create user #{u.email}"

  	u = User.create(title: "Mr", first_name: "Sanjay", last_name: "Kava", email: "sanjay@connuct.co.uk", password: "sanjay@connuct.co.uk",
  	role: "Agency", phone: "999999999", postcode: PostCode.first.postcode, confirmation_sent_at: Time.now, confirmed_at: Time.now,
  	sex: "M", accept_terms: true, phone_verified: true, agency_id: a.id )
  	puts "Create user #{u.email}"


    u = User.create(title: "Miss", first_name: "Sree", last_name: "Bhimavarapu", email: "S.Bhimavarapu@connuct.co.uk", password: "S.Bhimavarapu@connuct.co.uk",
    role: "Agency", phone: "999999999", postcode: PostCode.first.postcode, confirmation_sent_at: Time.now, confirmed_at: Time.now,
    sex: "F", accept_terms: true, phone_verified: true, agency_id: a.id )
    puts "Create user #{u.email}"
  end


  task :addAgencyMappings => :environment do
  	a = Agency.first
  	puts "Creating AgencyCareHomeMapping"
  	CareHome.all.each do |c|
  		AgencyCareHomeMapping.create(agency_id: a.id, care_home_id: c.id,  
  			care_home_broadcast_group: c.care_home_broadcast_group, manual_assignment_flag: c.manual_assignment_flag, 
  			preferred_care_giver_ids: c.preferred_care_giver_ids, limit_shift_to_pref_carer: c.limit_shift_to_pref_carer,
  			verified: true, accepted: true)

  	end

  	puts "Creating AgencyUserMapping"
  	User.temps.all.each do |u|
  		AgencyUserMapping.create(agency_id: a.id, user_id: u.id, verified: u.verified, accepted: true)
  	end

  end


  task :addAgencyIdToAll => :environment do
  	a = Agency.first
  	
  	puts "Updating agency id"

  	#Holiday.update_all(agency_id: a.id)
  	Payment.update_all(agency_id: a.id)
  	Profile.update_all(agency_id: a.id)
  	Rate.update_all(agency_id: a.id)
  	Rating.update_all(agency_id: a.id)
  	RecurringRequest.update_all(agency_id: a.id)
  	Shift.update_all(agency_id: a.id)
  	StaffingRequest.update_all(agency_id: a.id)
  	Training.update_all(agency_id: a.id)
  	Stat.update_all(agency_id: a.id)

  end

  task :migrateAgencyData => [:addNewAgency, :addAgencyMappings, :addAgencyIdToAll] do
    puts "Migrating all data to agency model"
  end


end