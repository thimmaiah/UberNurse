class ReferenceJob < ApplicationJob
  queue_as :default

  def perform
    
    Reference.not_received.where(
    	"(created_at >= ? and created_at <=?) or 
    	 (created_at >= ? and created_at <=?) or 
    	 (created_at >= ? and created_at <=?)", 
    	Date.today, Date.today - 1.day, 
    	Date.today - 3.days, Date.today - 4.days,
    	Date.today - 7.days, Date.today - 8.days).each do |ref|
    	
    	UserNotifierMailer.reference_notification(ref).deliver_now
    
    end

  end
end
