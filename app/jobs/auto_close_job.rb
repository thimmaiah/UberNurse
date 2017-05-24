# This job closes the open requests which have no responses and 
# have crossed the auto deny in time threshold
class AutoCloseJob < ApplicationJob
  
  queue_as :default

  def perform
    StaffingRequest.open.each do |req|

  		hours_from_creation = (Time.now - req.created_at)/(60*60) 
  		Rails.logger.debug "hours_from_creation = #{hours_from_creation}"
    	

    	if( hours_from_creation > req.auto_deny_in && 
    		req.staffing_responses.open.length == 0 )

    		req.request_status = "Auto Closed"
    		req.save
  
    	end
  
    end
    nil
  end

end
