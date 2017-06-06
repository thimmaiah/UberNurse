module RatesHelper

  # Give a price estimate for the request
  def price_estimate(staffing_request)
    rate = billing_rate(staffing_request)

    # Basic rate multiplication
    hours = staffing_request.minutes_worked / 60.0

    base = hours * rate.amount
    # Ensure we get the factor for surge pricing
    factor_name, factor_value = factor(staffing_request)
    billing = (base * factor_value).round(2)

    # Audit trail
    staffing_request.pricing_audit["hours_worked"] = hours
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
    hours = staffing_response.minutes_worked / 60.0

    base = hours * rate.amount
    # Ensure we get the factor for surge pricing
    factor_name, factor_value = factor(staffing_request)
    billing = (base * factor_value).round(2)

    # Audit trail
    staffing_response.pricing_audit["hours_worked"] = hours
    staffing_response.pricing_audit["base_rate"] = rate.amount
    staffing_response.pricing_audit["base_price"] = base
    staffing_response.pricing_audit["factor_value"] = factor_value
    staffing_response.pricing_audit["factor_name"] = factor_name
    staffing_response.pricing_audit["price"] = billing
    staffing_response.price = billing

    logger.debug(staffing_response.pricing_audit)

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
    if(staffing_request.start_date.hour > 20 || staffing_request.start_date.hour < 8)
      staffing_request.pricing_audit["NIGHT_FACTOR"] = ENV["NIGHT_FACTOR"].to_f
      hash["NIGHT_FACTOR"] = ENV["NIGHT_FACTOR"].to_f
    end

    if(staffing_request.end_date.hour > 20 || staffing_request.end_date.hour < 8)
      staffing_request.pricing_audit["NIGHT_FACTOR"] = ENV["NIGHT_FACTOR"].to_f
      hash["NIGHT_FACTOR"] = ENV["NIGHT_FACTOR"].to_f
    end

    # Return the max factor
    return hash.max_by{|k,v| v}

  end

  def get_night_shift_minutes(entity)
    night_shift_start = nil
    night_shift_end   = nil

    puts "entity.start_date.hour = #{entity.start_date.hour}, entity.end_date.hour = #{entity.end_date.hour}"

    if( (entity.start_date.hour <= 8 && entity.end_date.hour <= 8) ||
        (entity.start_date.hour >= 20 && entity.end_date.hour >= 20) ||
        (entity.start_date.hour >= 20 && entity.end_date.hour <= 8))
      night_shift_start = entity.start_date
      night_shift_end   = entity.end_date

    elsif(entity.start_date.hour <= 8 && entity.end_date.hour >= 8)
      night_shift_start = entity.start_date
      night_shift_end   = entity.end_date.change({hour:8,min:0,sec:0})

    elsif(entity.start_date.hour >= 20 && entity.end_date.hour >= 8)
      night_shift_start = entity.start_date
      night_shift_end = entity.end_date.change({hour:8,min:0,sec:0})

    elsif(entity.start_date.hour <= 20 && entity.end_date.hour <= 8)
      night_shift_start = entity.start_date.change({hour:20,min:0,sec:0})
      night_shift_end   = entity.end_date

    elsif(entity.start_date.hour <= 20 && entity.end_date.hour >= 20)
      night_shift_start = entity.start_date.change({hour:20,min:0,sec:0})
      night_shift_end = entity.end_date

    elsif(entity.start_date.hour <= 20 && entity.end_date.hour >= 8)
      night_shift_start = entity.start_date.change({hour:20,min:0,sec:0})
      night_shift_end = entity.end_date.change({hour:8,min:0,sec:0})

    end

    logger.debug "night_shift_end = #{night_shift_end}, night_shift_start = #{night_shift_start}"

    minutes = ((night_shift_end - night_shift_start).to_f / 60).round(0).to_f
    logger.debug "minutes = #{minutes}"

    ( minutes / 15).round * 15
    logger.debug "minutes rounded = #{minutes}"

    return minutes
  end

end
