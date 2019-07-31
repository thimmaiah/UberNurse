class ReferenceJob < ApplicationJob
  queue_as :default

  def perform
    
    Reference.where("created_at >= ? or created_at >= ? or created_at >= ?", 
    	Date.today, Date.today - 3.days, Date.today - 7.days).each do |ref|
    	UserNotifierMailer.reference_notification(ref).deliver_now
    end

  end
end
