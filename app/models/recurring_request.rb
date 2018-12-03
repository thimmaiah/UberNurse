class RecurringRequest < ApplicationRecord
	belongs_to :care_home
	belongs_to :user

	# Gives the weekdays on which the requests should be booked
	serialize :on, Array
	# Audit of all requests generated from this
	serialize :audit, Hash

	scope :open, -> {where("start_on <= ? and end_on >= ?", Date.today.beginning_of_day, Date.today.beginning_of_day)}

	def get_date(date, wday)
    	d = Date.today.beginning_of_week + date.strftime('%H').to_i.hours + date.strftime('%M').to_i.minutes + (wday - 1).days
    	d.in_time_zone("London").strftime("%d/%m/%Y %H:%M")
  	end
	
	def create_for_week(date=Date.today.beginning_of_week)
		if rr.audit[date] == nil
		  	logger.debug "RecurringRequest: Generating requests for #{date}."	
			rr.audit[date] = []
			# For each day that the request needs to be generated
			rr.on.each do |wday|
				rr.create_request(wday)
			end
      	else
      		logger.debug "RecurringRequest: Not generating requests for #{date}. Already generated."
        end
	end

	def create_request(wday)

		self.audit[Date.today.beginning_of_week] ||= []

		start_date = get_date(self.start_date, wday)
        end_date = get_date(self.end_date, wday) 

        req = StaffingRequest.new(care_home_id: self.care_home_id, user_id: self.user_id, 
                                  role: self.role, speciality: self.speciality, 
                                  start_date: start_date, end_date: end_date,
                                  start_code: rand.to_s[2..5], end_code: rand.to_s[2..5])

        req.save!
        logger.debug "RecurringRequest: Generated request #{req.to_json} for #{wday}"
        self.audit[Date.today.beginning_of_week] << req.id
        self.save
	end
end
