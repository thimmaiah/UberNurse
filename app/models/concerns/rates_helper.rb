module RatesHelper

  def price(staffing_request)
    rate = billing_rate(staffing_request)

    # Basic rate multiplication
    hours = staffing_request.minutes_worked / 60.0

    base = hours * rate.amount
    # Ensure we get the factor for surge pricing
    f = factor(staffing_request)
    billing = (base * f).round(2)

    logger.debug("hours=#{hours}, rate=#{rate.amount}, base = #{base}, factor = #{f}, billing=#{billing}")

    staffing_request.pricing_audit["hours_worked"] = hours
    staffing_request.pricing_audit["base_rate"] = rate.amount
    staffing_request.pricing_audit["base_price"] = base
    staffing_request.pricing_audit["factor"] = f
    staffing_request.pricing_audit["price"] = billing
    staffing_request.price = billing

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
      staffing_request.pricing_audit["WEEKEND_FACTOR"] = ENV["WEEKEND_FACTOR"].to_f
      return ENV["WEEKEND_FACTOR"].to_f
    end
    # Check last minute booking ?
    logger.debug("booking_start_diff_hrs = #{staffing_request.booking_start_diff_hrs}")
    if(staffing_request.booking_start_diff_hrs < 3)
      staffing_request.pricing_audit["LAST_MINUTE_FACTOR"] = ENV["LAST_MINUTE_FACTOR"].to_f
      return ENV["LAST_MINUTE_FACTOR"].to_f
    end
    # Bank holiday ?
    if(Holiday.isBankHoliday?(staffing_request.start_date) || Holiday.isBankHoliday?(staffing_request.end_date))
      staffing_request.pricing_audit["BANK_HOLIDAY_FACTOR"] = ENV["BANK_HOLIDAY_FACTOR"].to_f
      return ENV["BANK_HOLIDAY_FACTOR"].to_f
    end
    # night time ?
    if(staffing_request.start_date.hour > 20)
      staffing_request.pricing_audit["NIGHT_FACTOR"] = ENV["NIGHT_FACTOR"].to_f
      return ENV["NIGHT_FACTOR"].to_f
    end

    return 1
  end
end
