# This job closes the open requests which have no responses and
# have crossed the auto deny in time threshold
class AutoCloseJob < ApplicationJob

  queue_as :default

  def perform
    begin
      StaffingRequest.open.each do |req|

        hours_from_creation = (Time.now - req.created_at)/(60*60)
      Rails.logger.debug "hours_from_creation = #{hours_from_creation}"
      

      if( hours_from_creation > req.auto_deny_in && 
        req.staffing_responses.open.length == 0 )

        req.request_status = "Auto Closed"
        req.save
  
      end
  
    end
    rescue Exception => e
      logger.error "Error in SlotCreatorJob"
      logger.error e.backtrace
    ensure
      # Run this again
      AutoCloseJob.set(wait: 30.minutes).perform_later
    end
    return nil
  end


  def self.add_to_queue
    if Delayed::Backend::ActiveRecord::Job.where("handler like '%AutoCloseJob%'").count == 0
      puts "AutoCloseJob queued"
      AutoCloseJob.set(wait: 30.minutes).perform_later
    else
      puts "AutoCloseJob already queued. Nothing done"
    end
  end

end
