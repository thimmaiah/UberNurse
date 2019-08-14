class ShiftSubscriber

  def self.after_create(shift)  	
  	broadcast_shift(shift)
  end

  def self.after_commit(shift)
  end

  def self.broadcast_shift(shift)
    if(shift.response_status != 'Rejected')
      Rails.logger.debug "ShiftSubscriber: Broadcasting shift #{shift.id}"
      PushNotificationJob.new.perform(shift)
      ShiftMailer.shift_notification(shift).deliver_later
      shift.send_shift_sms_notification(shift)
    end
  end

  def self.shift_cancelled(shift)
  	Rails.logger.debug "ShiftSubscriber: shift cancelled #{shift.id}"
  end
  
end