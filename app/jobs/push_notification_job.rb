require 'open-uri'

class PushNotificationJob < ApplicationJob

  SERVER_KEY = "AAAAi87r0As:APA91bGX4T2Mpkf9e1fC-mO4GBzDgfarGLkxFYHC0KOMrCihsGQiVx0vCG7ZpWwPhhQ6f1JHz1ExBYtbiRHej4OJo8T8UeHEHwxF0GHF3X6tgfvqY7oAZwvB7IynK9b7SUz_277bgpFl";

  queue_as :default

  def perform(user_id, response_id)
  	u = User.find(user_id)
  	push("UberNurse Notification", "A new slot has been allocated to you", u.push_token)
  end

  def push(title, message, push_token)
    pushMessage = "{\"data\":{\"title\":\"" + title + 
    			"\",\"message\":\"" + message +  
    			"\"},\"to\":\"" + push_token + "\"}";

    url = "https://fcm.googleapis.com/fcm/send"
    headers = {
    	"Authorization" => "key=" +  SERVER_KEY,
    	"Content-Type" => "application/json"
    }
    

    logger.info("Sending #{pushMessage} to #{url} with headers #{headers}")

  	RestClient.post(url, pushMessage, headers){ |response, request, result|
  		
  		logger.debug(response)

	  	case response.code
		   when 200
		    	logger.info "Push notification successfull"
		  	else
		    	logger.info "Push notification failed"
	  	end
	}

  end

end