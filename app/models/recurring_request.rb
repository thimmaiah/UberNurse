class RecurringRequest < ApplicationRecord


	validates_presence_of :agency_id, :user_id, :care_home_id
	belongs_to :agency
	belongs_to :care_home
	belongs_to :user
	belongs_to :preferred_carer, class_name: "User"
	has_many :staffing_requests

	# Audit of all requests generated from this
	serialize :audit, Hash
	serialize :dates, Array


	before_create :set_defaults
	def set_defaults
		self.start_on = self.start_date
		self.audit = {}
		self.speciality = "Generalist" if self.speciality == nil
	end

	# This takes the following params
	# time_only - this is the start_date or end_date put into the RecurringRequest, which captures the time
	# wday - the day of the week the request is being genrated for
	# week - The week for which the request is being generated 
	def get_date(time_only, wday, week)
    	d = week.beginning_of_week + time_only.strftime('%H').to_i.hours + time_only.strftime('%M').to_i.minutes + (wday - 1).days
    	d.in_time_zone("London").strftime("%d/%m/%Y %H:%M")
  	end
	
	

	def create_for_dates
		req_count = 0
		self.dates.each do |d|
			logger.debug "RecurringRequest: Generating requests for #{self.id} #{d}"
			date = Date.parse(d)
			start_date = date + self.start_date.strftime('%H').to_i.hours + self.start_date.strftime('%M').to_i.minutes
	        end_date = date + self.end_date.strftime('%H').to_i.hours + self.end_date.strftime('%M').to_i.minutes

			created = self.create_request(start_date, end_date)
			req_count += 1 if created
		end
		self.save
	end

	def create_request(start_date, end_date)

		if self.audit[start_date]
			logger.debug "RecurringRequest: Already generated request #{self.audit[start_date]} for #{start_date} and #{end_date}. Skipping"
		else
       
	        req = StaffingRequest.new(care_home_id: self.care_home_id, user_id: self.user_id, 
	                                  role: self.role, speciality: self.speciality,
	                                  agency_id: self.agency_id, 
	                                  start_date: start_date, end_date: end_date,
	                                  preferred_carer_id: self.preferred_carer_id,
	                                  recurring_request_id: self.id,
	                                  start_code: rand.to_s[2..5], end_code: rand.to_s[2..5])

	        req.save!
	        logger.debug "RecurringRequest: Generated request #{req.to_json} for #{start_date} and #{end_date}"
	        
	        self.audit[req.start_date] = "#{req.id}"
	    end
	end

	def preferred_carer
		User.find(preferred_carer_id) if preferred_carer_id
	end


end
