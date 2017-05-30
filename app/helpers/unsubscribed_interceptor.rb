class UnsubscribedInterceptor
  
  def self.delivering_email(message)
  	user = User.find_by_email(message.to)
  	if(!user.subscription)
    	message.perform_deliveries = false
    	Rails.logger.info "Blocking mail for #{message.to} as user is unsubscribed"
    end
  end

end