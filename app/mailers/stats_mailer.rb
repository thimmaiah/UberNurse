class StatsMailer < ApplicationMailer
	
	def stats_email(week=Date.today.beginning_of_week)
		@week = week
	    mail( :to => ENV['ADMIN_EMAIL'],
	          :subject => "Stats for week of #{@week}" )
	end
end