class RecurringRequest < ApplicationRecord
	belongs_to :care_home
	belongs_to :user

	# Gives the weekdays on which the requests should be booked
	serialize :on, Array
	# Audit of all requests generated from this
	serialize :audit, Hash

	scope :open, -> {where("start_on >= ? and end_on <= ?", Date.today.beginning_of_day, Date.today.beginning_of_day)}	

	before_create :set_defaults
	def set_defaults
		self.next_generation_date = self.start_on
	end

	def get_date(date, wday)
    	d = Date.today.beginning_of_week + date.strftime('%H').to_i.hours + date.strftime('%M').to_i.minutes + (wday - 1).days
    	d.in_time_zone("London").strftime("%d/%m/%Y %H:%M")
  	end
	
	def create_for_week(generate_from_date=self.next_generation_date)

		if(generate_from_date >= self.start_on && generate_from_date <= self.end_on)

			if self.audit[generate_from_date] == nil
			  	logger.debug "RecurringRequest: Generating requests for #{self.id} #{generate_from_date}."	
				# For each day that the request needs to be generated
				self.on.each do |wday|
					self.create_request(generate_from_date, wday)
				end
	      	else
	      		logger.debug "RecurringRequest: Not generating requests for id #{self.id} #{generate_from_date}. Already generated."
	        end
    	else
    		logger.debug "RecurringRequest: Not generating requests for id #{self.id} #{generate_from_date} which is outside start on #{self.start_on} and end on #{self.end_on}."
    	end
        
        self.next_generation_date = Date.today.next_week(:friday)
        self.save
	end

	def create_request(generate_from_date, wday)

		self.audit[generate_from_date] ||= []

		start_date = get_date(self.start_date, wday)
        end_date = get_date(self.end_date, wday) 

        sd = Date.parse(start_date)

        if(sd >= self.start_on && sd <= self.end_on)

	        req = StaffingRequest.new(care_home_id: self.care_home_id, user_id: self.user_id, 
	                                  role: self.role, speciality: self.speciality, 
	                                  start_date: start_date, end_date: end_date,
	                                  start_code: rand.to_s[2..5], end_code: rand.to_s[2..5])

	        req.save!
	        logger.debug "RecurringRequest: Generated request #{req.to_json} for Week: #{generate_from_date}, Day: #{wday}"
	        self.audit[generate_from_date] << req.id
	        self.save
	    else
	    	logger.debug "RecurringRequest: Not generating requests for id #{self.id} #{start_date} which is outside start on #{self.start_on} and end on #{self.end_on}."
	    end
	end
end
