module RatesHelper

  def get_night_factor(factor_name, factor_value)
    
    night_factor = ENV["NIGHT_FACTOR"].to_f
    
    case factor_name
      when "DEFAULT_FACTOR"
        night_factor = ENV["NIGHT_FACTOR"].to_f
      when "WEEKEND_FACTOR"
        night_factor = ENV["WEEKEND_NIGHT_FACTOR"].to_f
      when "BANK_HOLIDAY_FACTOR"
        night_factor = factor_value
      when "LAST_MINUTE_FACTOR"
        night_factor = factor_value
      else
        night_factor = factor_value
    end

    night_factor

  end

  def base_price(entity, rate, factor_name, factor_value)
    total_mins = entity.minutes_worked 
    night_mins = entity.night_shift_minutes
    day_mins = total_mins - night_mins

    night_factor = get_night_factor(factor_name, factor_value)
    base = (day_mins * factor_value + night_mins * night_factor) * rate.amount / 60

    return base, day_mins, night_mins, night_factor
  end

  # Give a price estimate for the request
  def price_estimate(staffing_request)
    rate = billing_rate(staffing_request)

    # Ensure we get the factor for weekend, bank holiday or surge pricing
    factor_name, factor_value = factor(staffing_request)
    
    # Basic rate multiplication
    base, day_mins, night_mins, night_factor = base_price(staffing_request, rate, factor_name, factor_value)

    billing = base.round(2)

    # Audit trail
    day_time_hours_worked = staffing_request.human_readable_time(day_mins)
    night_time_hours_worked = staffing_request.human_readable_time(night_mins)

    staffing_request.pricing_audit["day_time_hours_worked"] = day_time_hours_worked
    staffing_request.pricing_audit["night_time_hours_worked"] = night_time_hours_worked
    staffing_request.pricing_audit["base_rate"] = rate.amount
    staffing_request.pricing_audit["base_price"] = base
    staffing_request.pricing_audit["factor_value"] = factor_value
    staffing_request.pricing_audit["night_factor"] = night_factor
    staffing_request.pricing_audit["factor_name"] = factor_name
    staffing_request.pricing_audit["price"] = billing
    staffing_request.pricing_audit["calc"] = "day_time_hours_worked x base_rate x factor_value + night_time_hours_worked x base_rate x night_factor"
    staffing_request.pricing_audit["calc_vals"] = "#{day_time_hours_worked} x #{rate.amount} x #{factor_value} + #{night_time_hours_worked} x #{rate.amount} x #{night_factor}"
    staffing_request.price = billing 
    staffing_request.vat = billing * ENV["VAT"].to_f.round(2) 
    staffing_request.total_price = (billing + staffing_request.vat).round(2)

    logger.debug(staffing_request.pricing_audit)

    billing.round(0)

  end

  # Give the actual price for the hours worked in the shift
  def price_actual(shift)
    staffing_request = shift.staffing_request

    rate = billing_rate(staffing_request)

    # Ensure we get the factor for weekend, bank holiday or surge pricing
    factor_name, factor_value = factor(staffing_request)
    
    # Basic rate multiplication
    base, day_mins, night_mins, night_factor = base_price(shift, rate, factor_name, factor_value)

    billing = base.round(2)
    vat = billing * ENV["VAT"].to_f.round(2)     
    markup = (billing * ENV["MARKUP"].to_f).round(2)

    # Audit trail
    day_time_hours_worked = shift.human_readable_time(day_mins)
    night_time_hours_worked = shift.human_readable_time(night_mins)

    shift.pricing_audit["day_time_hours_worked"] = day_time_hours_worked
    shift.pricing_audit["night_time_hours_worked"] = night_time_hours_worked
    shift.pricing_audit["base_rate"] = rate.amount
    shift.pricing_audit["base_price"] = base
    shift.pricing_audit["night_factor"] = night_factor
    shift.pricing_audit["factor_value"] = factor_value
    shift.pricing_audit["factor_name"] = factor_name
    shift.pricing_audit["calc"] = "day_time_hours_worked x base_rate x factor_value + night_time_hours_worked x base_rate x night_factor"
    shift.pricing_audit["calc_vals"] = "#{day_time_hours_worked} x #{rate.amount} x #{factor_value} + #{night_time_hours_worked} x #{rate.amount} x #{night_factor}"
    shift.pricing_audit["billing"] = billing
    shift.pricing_audit["vat"] = vat
    shift.pricing_audit["markup"] = markup

    # Add the pricing data to the shift
    shift.billing = billing
    shift.vat = vat
    shift.markup = markup
    shift.price = (billing - markup).round(2)
    shift.total_price = (billing + vat).round(2)

    # Add the mins worked to the shift
    shift.day_mins_worked = day_mins
    shift.night_mins_worked = night_mins
    shift.total_mins_worked = day_mins + night_mins

    logger.debug("pricing_audit = #{shift.pricing_audit}")

    billing.round(0)

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
      logger.debug("Weekend factor applied to request #{staffing_request.start_date} #{staffing_request.start_date.on_weekend?} #{staffing_request.end_date} #{staffing_request.end_date.on_weekend?}" )
      staffing_request.pricing_audit["WEEKEND_FACTOR"] = ENV["WEEKEND_FACTOR"].to_f
      hash["WEEKEND_FACTOR"] = ENV["WEEKEND_FACTOR"].to_f
    end
    # Check last minute booking ?
    
    if(staffing_request.booking_start_diff_hrs <= 3)
      logger.debug("Last minute factor applied to request booking_start_diff_hrs = #{staffing_request.booking_start_diff_hrs}")
      staffing_request.pricing_audit["LAST_MINUTE_FACTOR"] = ENV["LAST_MINUTE_FACTOR"].to_f
      hash["LAST_MINUTE_FACTOR"] = ENV["LAST_MINUTE_FACTOR"].to_f
    end
    # Bank holiday ?
    if(Holiday.isBankHoliday?(staffing_request.start_date) || Holiday.isBankHoliday?(staffing_request.end_date))
      logger.debug("Bank holiday factor applied to request #{staffing_request.start_date} #{Holiday.isBankHoliday?(staffing_request.start_date)} #{staffing_request.end_date} #{Holiday.isBankHoliday?(staffing_request.end_date)}")
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
