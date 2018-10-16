class ShiftConfirmJob < ApplicationJob
  queue_as :default

  def perform
  	Rails.logger.info "ShiftConfirmJob: Start"
    # Send confirmations for every accepted shift, to ensure the care giver is going to show up
    Shift.accepted.each do |shift|
    	
    	Rails.logger.info "ShiftConfirmJob: checking #{shift.id}"
    	if(shift.send_confirm?)
    		Rails.logger.info "ShiftConfirmJob: sending confirm for #{shift.id}"
    		# Send a mail asking the user to confirm
    		UserNotifierMailer.shift_confirmation(shift).deliver        
    		shift.confirmation_sent()
        # Send a mail to the broacast group with the start / end codes
        UserNotifierMailer.send_codes_to_broadcast_group(shift).deliver
    	end
    	
    end

    Rails.logger.info "ShiftConfirmJob: End"
  end
end
