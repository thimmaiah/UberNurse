class StatsMailer < ApplicationMailer
	layout "system_mailer"
	def stats_email(week=Date.today.beginning_of_week)
		@week = week
	    mail( :to => "#{ENV['ADMIN_EMAIL']}, #{ENV['MGT_EMAIL']}",
	          :subject => "Stats for week of #{@week}" )
	end

	def request_with_no_responses
		@staffing_requests = StaffingRequest.open.not_found
		mail( :to => "#{ENV['ADMIN_EMAIL']}, #{ENV['MGT_EMAIL']}",
	          :subject => "Requests with no responses: #{@staffing_requests.count}" )
	end
end