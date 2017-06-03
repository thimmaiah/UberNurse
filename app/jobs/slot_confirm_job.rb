class SlotConfirmJob < ApplicationJob
  queue_as :default

  def perform
  	Delayed::Worker.logger.info "SlotConfirmJob: Start"
    # Send confirmations for every accepted slot, to ensure the care giver is going to show up
    StaffingResponse.accepted.each do |staffing_response|
    	
    	Delayed::Worker.logger.info "SlotConfirmJob: checking #{staffing_response.id}"
    	if(staffing_response.send_confirm?)
    		Delayed::Worker.logger.info "SlotConfirmJob: sending confirm for #{staffing_response.id}"
    		# Send a mail asking the user to confirm
    		UserNotifierMailer.slot_confirmation(staffing_response).deliver
    		staffing_response.confirmation_sent()
    	end
    	
    end

    Delayed::Worker.logger.info "SlotConfirmJob: End"
  end
end
