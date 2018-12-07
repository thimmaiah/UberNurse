class RecurringRequest < ApplicationRecord
	belongs_to :care_home
	belongs_to :user

	# Audit of all requests generated from this
	serialize :audit, Hash

	# 3 days because we run the RecurringRequestJob on Friday - so it must generate the req for next Monday
	scope :ready_for_generation, -> {where("start_on <= ?  and end_on >= ?", Date.today + 7.days, Date.today)}	

	before_create :set_defaults
	def set_defaults
		self.start_on = self.start_date
		self.next_generation_date = self.start_date
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
	
	def create_for_week(week=self.next_generation_date)

		req_count = 0

		if(week >= self.start_on && week <= self.end_on)
			
			if self.audit[week] == nil
			  	logger.debug "RecurringRequest: Generating requests for #{self.id} #{week}."	
				# For each day that the request needs to be generated
				days = self.on.split(",").map{|x| x.to_i}
				days.each do |wday|
					created = self.create_request(week, wday)
					req_count += 1 if created
				end
	      	else
	      		logger.debug "RecurringRequest: Not generating requests for id #{self.id} #{week}. Already generated."
	        end
    	else
    		logger.debug "RecurringRequest: Not generating requests for id #{self.id} #{week} which is outside start on #{self.start_on} and end on #{self.end_on}."
    	end
        
        if(week.next_week <= self.end_on)
	        self.next_generation_date = week.next_week  
	        self.save
	    end

        return req_count
	end

	def create_request(week, wday)

		created = false
		self.audit[week] ||= []

		start_date = get_date(self.start_date, wday, week)
        end_date = get_date(self.end_date, wday, week) 

        sd = Date.parse(start_date)

        if(sd >= self.start_on && sd <= self.end_on)

	        req = StaffingRequest.new(care_home_id: self.care_home_id, user_id: self.user_id, 
	                                  role: self.role, speciality: self.speciality, 
	                                  start_date: start_date, end_date: end_date,
	                                  preferred_carer_id: self.preferred_carer_id,
	                                  start_code: rand.to_s[2..5], end_code: rand.to_s[2..5])

	        req.save!
	        logger.debug "RecurringRequest: Generated request #{req.to_json} for Week: #{week}, Day: #{wday}"
	        
	        self.audit[week] << "#{req.id} on #{req.start_date} "
	        self.save
	        created = true
	    else
	    	logger.debug "RecurringRequest: Not generating requests for id #{self.id} #{start_date} which is outside start on #{self.start_on} and end on #{self.end_on}."
	    end

	    return created
	end

	def preferred_carer
		User.find(preferred_carer_id) if preferred_carer_id
	end


	def self.generate
	  	Rails.logger.info "RecurringRequest: Generate Start"
	    RecurringRequest.ready_for_generation.each do |rr|
	        rr.create_for_week
	    end
	    Rails.logger.info "RecurringRequest: Generate End"
	    nil
	end
end
