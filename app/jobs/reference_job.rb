class ReferenceJob < ApplicationJob
  queue_as :default

  def perform
    
    refs = Reference.not_received.where("(created_at >= ? and created_at <=?) or 
                                         (created_at >= ? and created_at <=?) or 
                                         (created_at >= ? and created_at <=?)", 
                                        Date.today - 1, Date.today, 
                                        Date.today - 4.days, Date.today - 3.days,
                                        Date.today - 8.days, Date.today - 7.days)

    Rails.logger.info "ReferenceJob.perform: #{refs.count}"
    
    refs.each do |ref|
    	
    	UserNotifierMailer.reference_notification(ref).deliver_now
    
    end

  end
end
