module RatesHelper
  def price(staffing_request)
    rate = billing_rate(staffing_request)

    # Basic rate multiplication
    hours = staffing_request.minutes_worked / 60
    mins = staffing_request.minutes_worked % 60

    base = (hours + mins) * rate.amount
    # Ensure we get the factor for surge pricing
    f = factor(staffing_request)
    billing = base * f

    logger.debug("hours=#{hours}, mins=#{mins}, rate=#{rate.amount}, base = #{base}, factor = #{f}, billing=#{billing}")

    billing

  end

  def billing_rate(staffing_request)
    rate = Rate.where(zone: staffing_request.care_home.zone, role: staffing_request.role, speciality: staffing_request.speciality).first
    rate = Rate.where(zone: staffing_request.care_home.zone, role: staffing_request.role).first if !rate
    rate
  end

  def factor(staffing_request)
    # Now check if we need to multiply by a factor - weekend booking ?
    if(staffing_request.start_date.on_weekend? || staffing_request.end_date.on_weekend?)
      return ENV["WEEKEND_FACTOR"]
    end
    # Check last minute booking ?
    if(staffing_request.booking_start_diff_hrs < 3)
      return ENV["LAST_MINUTE_FACTOR"]
    end
    # Bank holiday ?
    if(Holiday.isBankHoliday?(staffing_request.start_date) || Holiday.isBankHoliday?(staffing_request.end_date))
      return ENV["BANK_HOLIDAY_FACTOR"]
    end
    # night time ?
    if(staffing_request.start_date.hour > 20)
      return ENV["NIGHT_FACTOR"]
    end

    return 1
  end
end
