class ShiftConfirmJob < ApplicationJob
  queue_as :default

  def perform
  	Delayed::Worker.logger.info "ShiftConfirmJob: Start"
    # Send confirmations for every accepted shift, to ensure the care giver is going to show up
    Shift.accepted.each do |shift|
    	
    	Delayed::Worker.logger.info "ShiftConfirmJob: checking #{shift.id}"
    	if(shift.send_confirm?)
    		Delayed::Worker.logger.info "ShiftConfirmJob: sending confirm for #{shift.id}"
    		# Send a mail asking the user to confirm
    		UserNotifierMailer.shift_confirmation(shift).deliver
    		shift.confirmation_sent()
    	end
    	
    end

    Delayed::Worker.logger.info "ShiftConfirmJob: End"
  end
end
