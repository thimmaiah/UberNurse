class StaffingRequestSubscriber

  def self.after_create(staffing_request)  	
  	UserNotifierMailer.staffing_request_created(staffing_request).deliver_later
  end

  def self.after_commit(staffing_request)
  end
  
end