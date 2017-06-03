class SlotPendingJob < ApplicationJob
  queue_as :default
  MAX_PENDING_SLOT_TIME_MINS = ENV["MAX_PENDING_SLOT_TIME_MINS"].to_i

  def perform()
    Delayed::Worker.logger.info "SlotPendingJob Start"
    begin
      # Find all the pending slots
      StaffingResponse.pending.each do |staffing_response|
        # Check if the slot has exceeded MAX_PENDING_SLOT_TIME_MINS
        time_elapsed =  (Time.now - staffing_response.created_at)/60
        if( time_elapsed > MAX_PENDING_SLOT_TIME_MINS)
        # No acceptance received, Lets Auto Reject        
        Delayed::Worker.logger.info("Slot #{staffing_response.id} for #{staffing_response.user.email}"\
          " has not been accepted for #{time_elapsed} minutes. Auto Rejected")
          staffing_response.response_status = "Auto Rejected"
          staffing_response.save!
        end
    end

    rescue Exception => e
      logger.error "Error in SlotPendingJob: #{e.message}"
      logger.error e.backtrace
    ensure
      # Run this again
      SlotPendingJob.set(wait: MAX_PENDING_SLOT_TIME_MINS.minute).perform_later
    end

    Delayed::Worker.logger.info "SlotPendingJob End"
    return nil
  end

  def self.add_to_queue
    if Delayed::Backend::ActiveRecord::Job.where("handler like '%SlotPendingJob%'").count == 0
      puts "SlotPendingJob queued"
      SlotPendingJob.set(wait: MAX_PENDING_SLOT_TIME_MINS.minute).perform_later
    else
      puts "SlotPendingJob already queued. Nothing done"
    end
  end
end
