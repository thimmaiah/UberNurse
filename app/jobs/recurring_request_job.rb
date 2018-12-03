class RecurringRequestJob < ApplicationJob
  
  queue_as :default

  def perform
  	Rails.logger.info "RecurringRequestJob: Start"
    begin
      RecurringRequest.open.each do |rr|
        # Check We've not generated the requests for the week and then lets proceed
        rr.create_for_week
      end
    rescue Exception => e    
      Rails.logger.error "ShiftConfirmJob: #{e.message}"
      ExceptionNotifier.notify_exception(e)
    ensure
      RecurringRequestJob.set(wait: 1.day).perform_later
    end
    Rails.logger.info "RecurringRequestJob: End"
  end
end
