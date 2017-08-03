class ShiftPendingJob < ApplicationJob
  queue_as :default
  MAX_PENDING_SLOT_TIME_MINS = ENV["MAX_PENDING_SLOT_TIME_MINS"].to_i

  def perform()
    Rails.logger.info "ShiftPendingJob: Start"
    begin
      # Find all the pending shifts
      Shift.pending.each do |shift|
        # Check if the shift has exceeded MAX_PENDING_SLOT_TIME_MINS
        time_elapsed =  (Time.now - shift.created_at)/60
        if( time_elapsed > MAX_PENDING_SLOT_TIME_MINS)
        # No acceptance received, Lets Auto Reject        
        Rails.logger.info("ShiftPendingJob: Shift #{shift.id} for #{shift.user.email}"\
          " has not been accepted for #{time_elapsed} minutes. Auto Rejected")
          shift.response_status = "Auto Rejected"
          shift.save!
        end
    end

    rescue Exception => e
      logger.error "Error in ShiftPendingJob: #{e.message}"
      logger.error e.backtrace
    ensure
      # Run this again
      ShiftPendingJob.set(wait: MAX_PENDING_SLOT_TIME_MINS.minutes).perform_later
    end

    Rails.logger.info "ShiftPendingJob: End"
    return nil
  end

  def self.add_to_queue
    if Delayed::Backend::ActiveRecord::Job.where("handler like '%ShiftPendingJob%'").count == 0
      Rails.logger.debug "ShiftPendingJob queued"
      ShiftPendingJob.set(wait: MAX_PENDING_SLOT_TIME_MINS.minutes).perform_later
    else
      puts "ShiftPendingJob already queued. Nothing done"
    end
  end
end
