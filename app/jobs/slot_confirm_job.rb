class SlotConfirmJob < ApplicationJob
  queue_as :default

  def perform
  	Rails.logger.info "SlotConfirmJob: Start"
    # Send confirmations for every accepted slot, to ensure the care giver is going to show up
    StaffingResponse.accepted.each do |staffing_response|
    	
    	Rails.logger.info "SlotConfirmJob: checking #{staffing_response.id}"
    	if(staffing_response.send_confirm?)
    		Rails.logger.info "SlotConfirmJob: sending confirm for #{staffing_response.id}"
    		# Send a mail asking the user to confirm
    		UserNotifierMailer.slot_confirmation(staffing_response).deliver
    		staffing_response.confirmation_sent()
    	end
    	
    end

    Rails.logger.info "SlotConfirmJob: End"
  end
end
