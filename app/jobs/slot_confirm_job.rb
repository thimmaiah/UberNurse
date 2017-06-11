class SlotConfirmJob < ApplicationJob
  queue_as :default

  def perform
  	Delayed::Worker.logger.info "SlotConfirmJob: Start"
    # Send confirmations for every accepted slot, to ensure the care giver is going to show up
    Shift.accepted.each do |shift|
    	
    	Delayed::Worker.logger.info "SlotConfirmJob: checking #{shift.id}"
    	if(shift.send_confirm?)
    		Delayed::Worker.logger.info "SlotConfirmJob: sending confirm for #{shift.id}"
    		# Send a mail asking the user to confirm
    		UserNotifierMailer.slot_confirmation(shift).deliver
    		shift.confirmation_sent()
    	end
    	
    end

    Delayed::Worker.logger.info "SlotConfirmJob: End"
  end
end
