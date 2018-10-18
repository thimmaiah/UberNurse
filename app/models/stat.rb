class Stat < ApplicationRecord

  after_save ThinkingSphinx::RealTime.callback_for(:stat)

  def self.generate_all(date=Date.today)
  	Rails.logger.debug "Generating stats for #{date}"
    self.user_stats(date)
    self.care_home_stats(date)
    self.staffing_request_stats(date)
    self.shift_stats(date)
    self.generate_financials(date)
  end

  def self.user_stats(date=Date.today)

    week = date.beginning_of_week
    month = date.beginning_of_month
    type = "User"

    # We will regenerate this week, month and all time - so delete it before we regenerate
    Stat.where("stat_type = ? and date_range in (?)", type, ["Week of #{week}", "Month of #{month}", "All Time"]).delete_all

    [true, false].each do |verified|
      vFlag = verified ? "Verified" : "Unverified"

      name = "Total #{vFlag} User Count"

      Stat.create(name: name, stat_type: type, description: "All #{vFlag} users",
                  as_of_date: date, date_range: "Week of #{week}", 
                  value: User.where("verified=? and  created_at >= ? and created_at <= ?", 
                  	verified, week, week.end_of_week).count)

      Stat.create(name: name, stat_type: type, description: "All #{vFlag} users",
                  as_of_date: date, date_range: "Month of #{month}", 
                  value: User.where("verified=? and  created_at >= ? and created_at <= ?", 
                  	verified, month, month.end_of_month).count)

      Stat.create(name: name, stat_type: type, description: "All #{vFlag} users",
                  as_of_date: date, date_range: "All time", 
                  value: User.where("verified=?", verified).count)



      User::ROLE.each do |role|
        name = "Total #{vFlag} #{role} Count"

        Stat.create(name: name , stat_type: type, description: "All #{vFlag} #{role}",
                    as_of_date: date, date_range: "Week of #{week}", 
                    value: User.where("verified=? and  role = ? and created_at >= ? and created_at <= ?", 
                    	verified, role, week, week.end_of_week).count)

        Stat.create(name: name, stat_type: type, description: "All #{vFlag} #{role}",
                    as_of_date: date, date_range: "Month of #{month}", 
                    value: User.where("verified=? and  role = ? and created_at >= ? and created_at <= ?", 
                    	verified, role, month, month.end_of_month).count)

        Stat.create(name: name, stat_type: type, description: "All #{vFlag} #{role}",
                    as_of_date: date, date_range: "All time", 
                    value: User.where("verified=? and  role = ?", verified, role).count)

      end
    end
  end



  def self.care_home_stats(date=Date.today)

    week = date.beginning_of_week
    month = date.beginning_of_month
    type = "CareHome"


    # We will regenerate this week, month and all time - so delete it before we regenerate
    Stat.where("stat_type = ? and date_range in (?)", type, ["Week of #{week}", "Month of #{month}", "All Time"]).delete_all


    [true, false].each do |verified|
      vFlag = verified ? "Verified" : "Unverified"

      name = "Total #{vFlag} Care Home Count"

      Stat.create(name: name, stat_type: type, description: "All #{vFlag} care homes",
                  as_of_date: date, date_range: "Week of #{week}", 
                  value: CareHome.where("verified=? and  created_at >= ? and created_at <= ?", 
                  	verified, week, week.end_of_week).count)

      Stat.create(name: name, stat_type: type, description: "All #{vFlag} care_homes",
                  as_of_date: date, date_range: "Month of #{month}", 
                  value: CareHome.where("verified=? and  created_at >= ? and created_at <= ?", 
                  	verified, month, month.end_of_month).count)

      Stat.create(name: name, stat_type: type, description: "All #{vFlag} care_homes",
                  as_of_date: date, date_range: "All time", 
                  value: CareHome.where("verified=?", verified).count)



      CareHome::ZONES.each do |zone|
        name = "Care Home #{vFlag} #{zone} Zone Count"

        Stat.create(name: name , stat_type: type, description: "All #{vFlag} #{zone}",
                    as_of_date: date, date_range: "Week of #{week}", 
                    value: CareHome.where("verified=? and  zone = ? and created_at >= ? and created_at <= ?", 
                    	verified, zone  , week, week.end_of_week).count)

        Stat.create(name: name, stat_type: type, description: "All #{vFlag} #{zone}",
                    as_of_date: date, date_range: "Month of #{month}", 
                    value: CareHome.where("verified=? and  zone   = ? and created_at >= ? and created_at <= ?", 
                    	verified, zone  ,month, month.end_of_month).count)

        Stat.create(name: name, stat_type: type, description: "All #{vFlag} #{zone}",
                    as_of_date: date, date_range: "All time", 
                    value: CareHome.where("verified=? and  zone   = ?", verified, zone  ).count)

      end
    end
  end

  def self.staffing_request_stats(date=Date.today)

    week = date.beginning_of_week
    month = date.beginning_of_month
    type = "StaffingRequest"


    # We will regenerate this week, month and all time - so delete it before we regenerate
    Stat.where("stat_type = ? and date_range in (?)", type, ["Week of #{week}", "Month of #{month}", "All Time"]).delete_all


    StaffingRequest::REQ_STATUS.each do |status|

      name = "Total #{status} StaffingRequest Count"
      desc = "#{status} StaffingRequest"

      Stat.create(name: name, stat_type: type, description: desc,
                  as_of_date: date, date_range: "Week of #{week}", 
                  value: StaffingRequest.where("request_status=? and  created_at >= ? and created_at <= ?", 
                  	status  , week, week.end_of_week).count)

      Stat.create(name: name, stat_type: type, description: desc,
                  as_of_date: date, date_range: "Month of #{month}", 
                  value: StaffingRequest.where("request_status=? and  created_at >= ? and created_at <= ?", 
                  	status  , month, month.end_of_month).count)

      Stat.create(name: name, stat_type: type, description: desc,
                  as_of_date: date, date_range: "All time", 
                  value: StaffingRequest.where("request_status=?", status  ).count)

    end

    StaffingRequest::SHIFT_STATUS.each do |status|

      name = "Total Shifts: #{status} StaffingRequest Count"
      desc = "Shifts: #{status} StaffingRequest"

      Stat.create(name: name, stat_type: type, description: desc,
                  as_of_date: date, date_range: "Week of #{week}", 
                  value: StaffingRequest.where("shift_status=? and  created_at >= ? and created_at <= ?", 
                  	status  , week, week.end_of_week).count)

      Stat.create(name: name, stat_type: type, description: desc,
                  as_of_date: date, date_range: "Month of #{month}", 
                  value: StaffingRequest.where("shift_status=? and  created_at >= ? and created_at <= ?", 
                  	status  , month, month.end_of_month).count)

      Stat.create(name: name, stat_type: type, description: desc,
                  as_of_date: date, date_range: "All time", 
                  value: StaffingRequest.where("shift_status=?", status  ).count)

    end

  end

  def self.shift_stats(date=Date.today)

    week = date.beginning_of_week
    month = date.beginning_of_month
    type = "Shift"


    # We will regenerate this week, month and all time - so delete it before we regenerate
    Stat.where("stat_type = ? and date_range in (?)", type, ["Week of #{week}", "Month of #{month}", "All Time"]).delete_all


    Shift::RESPONSE_STATUS.each do |status|

      name = "Total #{status} Shift Count"
      desc = "#{status} Shift"

      Stat.create(name: name, stat_type: type, description: desc,
                  as_of_date: date, date_range: "Week of #{week}", 
                  value: Shift.where("response_status  =? and  created_at >= ? and created_at <= ?", 
                  	status  , week, week.end_of_week).count)

      Stat.create(name: name, stat_type: type, description: desc,
                  as_of_date: date, date_range: "Month of #{month}", 
                  value: Shift  .where("response_status  =? and  created_at >= ? and created_at <= ?", 
                  	status  , month, month.end_of_month).count)

      Stat.create(name: name, stat_type: type, description: desc,
                  as_of_date: date, date_range: "All time", 
                  value: Shift.where("response_status  =?", status  ).count)

    end

  end

  def self.generate_financials(date=Date.today)

    week = date.beginning_of_week
    month = date.beginning_of_month
    type = "Financials"
    desc = "Financials"
    status = "Closed"

    # We will regenerate this week, month and all time - so delete it before we regenerate
    Stat.where("stat_type = ? and date_range in (?)", type, ["Week of #{week}", "Month of #{month}", "All Time"]).delete_all


    Stat.create(name: "Income from Care Homes", stat_type: type, description: desc,
                as_of_date: date, date_range: "Week of #{week}", 
                value: Shift.where("response_status  =? and  created_at >= ? and created_at <= ?",
                      				status  , week, week.end_of_week).sum(:care_home_total_amount).round(2))

    Stat.create(name: "Expenses for Care Givers", stat_type: type, description: desc,
                as_of_date: date, date_range: "Week of #{week}",
                value: Shift.where("response_status  =? and  created_at >= ? and created_at <= ?",
                                   status  , week, week.end_of_week).sum(:carer_base).round(2))

    Stat.create(name: "Hours worked by Care Givers", stat_type: type, description: desc,
                as_of_date: date, date_range: "Week of #{week}",
                value: (Shift.where("response_status  =? and  created_at >= ? and created_at <= ?",
                                    status  , week, week.end_of_week).sum(:total_mins_worked) / 60).round(2))

    Stat.create(name: "Income from Care Homes", stat_type: type, description: desc,
                as_of_date: date, date_range: "Month of #{month}",
                value: Shift.where("response_status  =? and  created_at >= ? and created_at <= ?",
                                   status  , month, month.end_of_month).sum(:care_home_total_amount).round(2))

    Stat.create(name: "Expenses for Care Givers", stat_type: type, description: desc,
                as_of_date: date, date_range: "Month of #{month}",
                value: Shift.where("response_status  =? and  created_at >= ? and created_at <= ?",
                                   status  , month, month.end_of_month).sum(:carer_base).round(2))

    Stat.create(name: "Hours worked by Care Givers", stat_type: type, description: desc,
                as_of_date: date, date_range: "Month of #{month}",
                value: (Shift.where("response_status  =? and  created_at >= ? and created_at <= ?",
                                    status  , month, month.end_of_month).sum(:total_mins_worked) / 60).round(2))

    Stat.create(name: "Income from Care Homes", stat_type: type, description: desc,
                as_of_date: date, date_range: "All time",
                value: Shift.where("response_status  =?", status).sum(:care_home_total_amount).round(2))

    Stat.create(name: "Expenses for Care Givers", stat_type: type, description: desc,
                as_of_date: date, date_range: "All time",
                value: Shift.where("response_status  =?", status).sum(:carer_base).round(2))

    Stat.create(name: "Hours worked by Care Givers", stat_type: type, description: desc,
                as_of_date: date, date_range: "All time",
                value: (Shift.where("response_status  =? ", status).sum(:total_mins_worked) / 60).round(2))

  end

  def self.graph_data(stat_type, duration="Month")
    user_stats = Stat.search(duration, with: {stat_type: stat_type}, order: :as_of_date, page: 1, per_page: 100)
  end

  def self.generate_from(start_date)
  	s = start_date.end_of_week
  	while( s < Date.today.beginning_of_week ) 
  		self.generate_all(s)
  		s = s + 7.days
  	end
  end

end
