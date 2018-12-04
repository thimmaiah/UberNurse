module StartEndTimeHelper


  def minutes_worked
    if(self.start_date && self.end_date)
      minutes = ((self.end_date - self.start_date).to_f / 60).round(0).to_f
    else
      0
    end
  end

  def human_readable_time(minutes)
    "#{(minutes / 60).truncate(0)} hrs, #{(minutes % 60).round(0)} mins"
  end

  def night_shift_minutes
    night_shift_start = 0
    night_shift_end   = 0
    night_shift_start2 = 0
    night_shift_end2   = 0

    minutes = nil

    logger.debug "self.start_date.hour = #{self.start_date.hour}, self.end_date.hour = #{self.end_date.hour}"

    if(self.start_date.day == self.end_date.day)
      if( (self.start_date.hour <= 8 && self.end_date.hour <= 8) ||
          (self.start_date.hour >= 20 && self.end_date.hour >= 20) ||
          (self.start_date.hour >= 20 && self.end_date.hour <= 8))
        night_shift_start = self.start_date
        night_shift_end   = self.end_date
        logger.debug "Condition 1"

      elsif(self.start_date.hour < 8 && self.end_date.hour >= 20)        
        # Here there are 2 separate night elements
        early_morning_shift = (self.end_date.change({hour:8,min:0,sec:0}) - self.start_date).to_f / 60
        late_night_shift = (self.end_date - self.end_date.change({hour:20,min:0,sec:0})).to_f / 60
        
        minutes = early_morning_shift + late_night_shift
        
        logger.debug "early_morning_shift = #{early_morning_shift} late_night_shift = #{late_night_shift} Condition 1.5"

      elsif(self.start_date.hour < 8 && self.end_date.hour >= 8)
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
      end
    end

    if(self.start_date.day != self.end_date.day)

      if(self.start_date.hour <= 20 && self.end_date.hour >= 8)
        night_shift_start = self.start_date.change({hour:20,min:0,sec:0})
        night_shift_end = self.end_date.change({hour:8,min:0,sec:0})
        logger.debug "Condition 7"

      elsif(self.start_date.hour >=8 && self.start_date.hour <= 20 && self.end_date.hour <= 8)
        night_shift_start = self.start_date.change({hour:20,min:0,sec:0})
        night_shift_end = self.end_date
        logger.debug "Condition 8"

      elsif(self.start_date.hour >= 20 && self.end_date.hour >= 8 && self.end_date.hour <= 20)
        night_shift_start = self.start_date
        night_shift_end = self.end_date.change({hour:8,min:0,sec:0})
        logger.debug "Condition 9"

      elsif(self.start_date.hour >= 20 && self.end_date.hour <= 8)
        night_shift_start = self.start_date
        night_shift_end = self.end_date
        logger.debug "Condition 10"

      elsif(self.start_date.hour <= 8 && self.end_date.hour <= 8)
        # Here there are 2 separate night elements
        early_morning_shift = (self.start_date.change({hour:8,min:0,sec:0}) - self.start_date).to_f / 60
        late_night_shift = (self.end_date - self.start_date.change({hour:20,min:0,sec:0})).to_f / 60
        
        minutes = early_morning_shift + late_night_shift
        logger.debug "Condition 11"

      elsif(self.start_date.hour >= 20 && self.end_date.hour >= 20)
        # Here there are 2 separate night elements
        early_morning_shift = (self.end_date.change({hour:8,min:0,sec:0}) - self.start_date).to_f / 60
        late_night_shift = (self.end_date - self.end_date.change({hour:20,min:0,sec:0})).to_f / 60
        
        minutes = early_morning_shift + late_night_shift
        logger.debug "Condition 12"

      end
    end

    logger.debug "night_shift_end = #{night_shift_end}, night_shift_start = #{night_shift_start}, night_shift_end2 = #{night_shift_end2}, night_shift_start2 = #{night_shift_start2}"

    minutes = ((night_shift_end - night_shift_start).to_f / 60) if minutes == nil # Hack for Condition 10
    minutes = minutes.round(0).to_f
    logger.debug "minutes = #{minutes}"

    return minutes
  end

end
