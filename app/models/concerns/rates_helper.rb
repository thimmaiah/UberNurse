module RatesHelper

  def base_price(entity, rate)
    total_mins = entity.minutes_worked 
    night_mins = entity.night_shift_minutes
    day_mins = total_mins - night_mins

    night_factor = ENV["NIGHT_FACTOR"].to_f
    base = (day_mins  + night_mins * night_factor) * rate.amount / 60

    return base, day_mins, night_mins
  end

  # Give a price estimate for the request
  def price_estimate(staffing_request)
    rate = billing_rate(staffing_request)

    # Basic rate multiplication
    base, day_mins, night_mins = base_price(staffing_request, rate)

    # Ensure we get the factor for surge pricing
    factor_name, factor_value = factor(staffing_request)
    billing = (base * factor_value).round(2)

    # Audit trail
    staffing_request.pricing_audit["day_time_hours_worked"] = staffing_request.human_readable_time(day_mins)
    staffing_request.pricing_audit["night_time_hours_worked"] = staffing_request.human_readable_time(night_mins)
    staffing_request.pricing_audit["base_rate"] = rate.amount
    staffing_request.pricing_audit["base_price"] = base
    staffing_request.pricing_audit["factor_value"] = factor_value
    staffing_request.pricing_audit["factor_name"] = factor_name
    staffing_request.pricing_audit["price"] = billing
    staffing_request.price = billing

    logger.debug(staffing_request.pricing_audit)

    billing

  end

  # Give the actual price for the hours worked in the slot
  def price_actual(staffing_response)
    staffing_request = staffing_response.staffing_request

    rate = billing_rate(staffing_request)

    # Basic rate multiplication
    base, day_mins, night_mins = base_price(staffing_response, rate)

    # Ensure we get the factor for surge pricing
    factor_name, factor_value = factor(staffing_request)
    billing = (base * factor_value).round(2)

    # Audit trail
    staffing_response.pricing_audit["day_time_hours_worked"] = staffing_response.human_readable_time(day_mins)
    staffing_response.pricing_audit["night_time_hours_worked"] = staffing_response.human_readable_time(night_mins)
    staffing_response.pricing_audit["base_rate"] = rate.amount
    staffing_response.pricing_audit["base_price"] = base
    staffing_response.pricing_audit["factor_value"] = factor_value
    staffing_response.pricing_audit["factor_name"] = factor_name
    staffing_response.pricing_audit["price"] = billing
    staffing_response.price = billing

    logger.debug("pricing_audit = #{staffing_response.pricing_audit}")

    billing

  end


  def billing_rate(staffing_request)
    #rate = Rate.where(zone: staffing_request.care_home.zone, role: staffing_request.role, speciality: staffing_request.speciality).first
    rate = Rate.where(zone: staffing_request.care_home.zone, role: staffing_request.role).first
    rate
  end

  def factor(staffing_request)

    hash = {"DEFAULT_FACTOR"=>1}
    # Now check if we need to multiply by a factor - weekend booking ?
    if(staffing_request.start_date.on_weekend? || staffing_request.end_date.on_weekend?)
      staffing_request.pricing_audit["WEEKEND_FACTOR"] = ENV["WEEKEND_FACTOR"].to_f
      hash["WEEKEND_FACTOR"] = ENV["WEEKEND_FACTOR"].to_f
    end
    # Check last minute booking ?
    logger.debug("booking_start_diff_hrs = #{staffing_request.booking_start_diff_hrs}")
    if(staffing_request.booking_start_diff_hrs <= 3)
      staffing_request.pricing_audit["LAST_MINUTE_FACTOR"] = ENV["LAST_MINUTE_FACTOR"].to_f
      hash["LAST_MINUTE_FACTOR"] = ENV["LAST_MINUTE_FACTOR"].to_f
    end
    # Bank holiday ?
    if(Holiday.isBankHoliday?(staffing_request.start_date) || Holiday.isBankHoliday?(staffing_request.end_date))
      staffing_request.pricing_audit["BANK_HOLIDAY_FACTOR"] = ENV["BANK_HOLIDAY_FACTOR"].to_f
      hash["BANK_HOLIDAY_FACTOR"] = ENV["BANK_HOLIDAY_FACTOR"].to_f
    end
    # night time ?
    # if(staffing_request.start_date.hour > 20 || staffing_request.start_date.hour < 8)
    #   staffing_request.pricing_audit["NIGHT_FACTOR"] = ENV["NIGHT_FACTOR"].to_f
    #   hash["NIGHT_FACTOR"] = ENV["NIGHT_FACTOR"].to_f
    # end


    # Return the max factor
    return hash.max_by{|k,v| v}

  end

  

end
