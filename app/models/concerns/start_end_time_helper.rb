module StartEndTimeHelper


  def minutes_worked
    if(self.start_date && self.end_date)
      minutes = ((self.end_date - self.start_date).to_f / 60).round(0).to_f
    else
      0
    end
  end

  def human_readable_time(minutes)
    "#{(minutes / 60).round(0)} hrs, #{(minutes % 60).round(0)} mins"
  end

  def night_shift_minutes
    night_shift_start = 0
    night_shift_end   = 0

    logger.debug "self.start_date.hour = #{self.start_date.hour}, self.end_date.hour = #{self.end_date.hour}"

    if( (self.start_date.hour <= 8 && self.end_date.hour <= 8) ||
        (self.start_date.hour >= 20 && self.end_date.hour >= 20) ||
        (self.start_date.hour >= 20 && self.end_date.hour <= 8))
      night_shift_start = self.start_date
      night_shift_end   = self.end_date
      logger.debug "Condition 1"

    elsif(self.start_date.hour <= 8 && self.end_date.hour >= 8)
      night_shift_start = self.start_date
      night_shift_end   = self.end_date.change({hour:8,min:0,sec:0})
      logger.debug "Condition 2"

    elsif(self.start_date.hour >= 20 && self.end_date.hour >= 8)
      night_shift_start = self.start_date
      night_shift_end = self.end_date.change({hour:8,min:0,sec:0})
      logger.debug "Condition 3"

    elsif(self.start_date.hour <= 20 && self.end_date.hour <= 8)
      night_shift_start = self.start_date.change({hour:20,min:0,sec:0})
      night_shift_end   = self.end_date
      logger.debug "Condition 4"

    elsif(self.start_date.hour <= 20 && self.end_date.hour >= 20)
      night_shift_start = self.start_date.change({hour:20,min:0,sec:0})
      night_shift_end = self.end_date
      logger.debug "Condition 5"

    elsif(self.start_date.hour >= 8 && self.end_date.hour <= 20)
      night_shift_start = 0
      night_shift_end   = 0
      logger.debug "Condition 6"
    elsif(self.start_date.hour <= 20 && self.end_date.hour >= 8)
      night_shift_start = self.start_date.change({hour:20,min:0,sec:0})
      night_shift_end = self.end_date.change({hour:8,min:0,sec:0})
      logger.debug "Condition 7"

    end

    logger.debug "night_shift_end = #{night_shift_end}, night_shift_start = #{night_shift_start}"

    minutes = ((night_shift_end - night_shift_start).to_f / 60).round(0).to_f
    logger.debug "minutes = #{minutes}"

    return minutes
  end

end
