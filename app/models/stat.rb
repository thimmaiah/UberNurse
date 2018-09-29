class Stat < ApplicationRecord

	after_save ThinkingSphinx::RealTime.callback_for(:stat)

	def self.user_stats(date=Date.today)

		week = date.beginning_of_week
		month = date.beginning_of_month
		type = "User"
		

		Stat.where(stat_type: type).delete_all

		[true, false].each do |verified|
			vFlag = verified ? "Verified" : "Unverified"
			
			name = "Total #{vFlag} User Count"

			Stat.create(name: name, stat_type: type, description: "All #{vFlag} users", 
				as_of_date: date, date_range: "Week of #{week}", value: User.where("verified=? and  created_at >= ?", verified, week).count)

			Stat.create(name: name, stat_type: type, description: "All #{vFlag} users", 
				as_of_date: date, date_range: "Month of #{month}", value: User.where("verified=? and  created_at >= ?", verified, month).count)

			Stat.create(name: name, stat_type: type, description: "All #{vFlag} users", 
				as_of_date: date, date_range: "All time", value: User.where("verified=?", verified).count)				
		

		
			User::ROLE.each do |role|
				name = "Total #{vFlag} #{role} Count"

				Stat.create(name: name , stat_type: type, description: "All #{vFlag} #{role}", 
					as_of_date: date, date_range: "Week of #{week}", value: User.where("verified=? and  role = ? and created_at >= ?", verified, role, week).count)

				Stat.create(name: name, stat_type: type, description: "All #{vFlag} #{role}", 
					as_of_date: date, date_range: "Month of #{month}", value: User.where("verified=? and  role = ? and created_at >= ?", verified, role, month).count)

				Stat.create(name: name, stat_type: type, description: "All #{vFlag} #{role}", 
					as_of_date: date, date_range: "All time", value: User.where("verified=? and  role = ?", verified, role).count)				

			end
		end
	end



	def self.care_home_stats(date=Date.today)

		week = date.beginning_of_week
		month = date.beginning_of_month
		type = "CareHome"
		

		Stat.where(stat_type: type).delete_all

		[true, false].each do |verified|
			vFlag = verified ? "Verified" : "Unverified"
			
			name = "Total #{vFlag} Care Home Count"

			Stat.create(name: name, stat_type: type, description: "All #{vFlag} care homes", 
				as_of_date: date, date_range: "Week of #{week}", value: CareHome.where("verified=? and  created_at >= ?", verified, week).count)

			Stat.create(name: name, stat_type: type, description: "All #{vFlag} care_homes", 
				as_of_date: date, date_range: "Month of #{month}", value: CareHome.where("verified=? and  created_at >= ?", verified, month).count)

			Stat.create(name: name, stat_type: type, description: "All #{vFlag} care_homes", 
				as_of_date: date, date_range: "All time", value: CareHome.where("verified=?", verified).count)				
		

		
			CareHome::ZONES.each do |zone|
				name = "Care Home #{vFlag} #{zone} Zone Count"

				Stat.create(name: name , stat_type: type, description: "All #{vFlag} #{zone}", 
					as_of_date: date, date_range: "Week of #{week}", value: CareHome.where("verified=? and  zone = ? and created_at >= ?", verified, zone  , week).count)

				Stat.create(name: name, stat_type: type, description: "All #{vFlag} #{zone}", 
					as_of_date: date, date_range: "Month of #{month}", value: CareHome.where("verified=? and  zone   = ? and created_at >= ?", verified, zone  , month).count)

				Stat.create(name: name, stat_type: type, description: "All #{vFlag} #{zone}", 
					as_of_date: date, date_range: "All time", value: CareHome.where("verified=? and  zone   = ?", verified, zone  ).count)				

			end
		end
	end

	def self.staffing_request_stats(date=Date.today)

		week = date.beginning_of_week
		month = date.beginning_of_month
		type = "StaffingRequest"
		

		Stat.where(stat_type: type).delete_all

		StaffingRequest::REQ_STATUS.each do |status|
			
			name = "Total #{status} StaffingRequest Count"
			desc = "#{status} StaffingRequest"

			Stat.create(name: name, stat_type: type, description: desc, 
				as_of_date: date, date_range: "Week of #{week}", value: StaffingRequest.where("request_status=? and  created_at >= ?", status  , week).count)

			Stat.create(name: name, stat_type: type, description: desc, 
				as_of_date: date, date_range: "Month of #{month}", value: StaffingRequest.where("request_status=? and  created_at >= ?", status  , month).count)

			Stat.create(name: name, stat_type: type, description: desc, 
				as_of_date: date, date_range: "All time", value: StaffingRequest.where("request_status=?", status  ).count)				
		
		end

		StaffingRequest::SHIFT_STATUS.each do |status|
			
			name = "Total Shifts: #{status} StaffingRequest Count"
			desc = "Shifts: #{status} StaffingRequest"

			Stat.create(name: name, stat_type: type, description: desc, 
				as_of_date: date, date_range: "Week of #{week}", value: StaffingRequest.where("shift_status=? and  created_at >= ?", status  , week).count)

			Stat.create(name: name, stat_type: type, description: desc, 
				as_of_date: date, date_range: "Month of #{month}", value: StaffingRequest.where("shift_status=? and  created_at >= ?", status  , month).count)

			Stat.create(name: name, stat_type: type, description: desc, 
				as_of_date: date, date_range: "All time", value: StaffingRequest.where("shift_status=?", status  ).count)				
		
		end

	end

	def self.shift_stats(date=Date.today)

		week = date.beginning_of_week
		month = date.beginning_of_month
		type = "Shift"
		

		Stat.where(stat_type: type).delete_all

		Shift::RESPONSE_STATUS.each do |status|
			
			name = "Total #{status} Shift Count"
			desc = "#{status} Shift"

			Stat.create(name: name, stat_type: type, description: desc, 
				as_of_date: date, date_range: "Week of #{week}", value: Shift.where("response_status  =? and  created_at >= ?", status  , week).count)

			Stat.create(name: name, stat_type: type, description: desc, 
				as_of_date: date, date_range: "Month of #{month}", value: Shift  .where("response_status  =? and  created_at >= ?", status  , month).count)

			Stat.create(name: name, stat_type: type, description: desc, 
				as_of_date: date, date_range: "All time", value: Shift.where("response_status  =?", status  ).count)				
		
		end

	end


end
