class UserNotifierMailer < ApplicationMailer

  # send a signup email to the user, pass in the user object that   contains the user's email address
  def user_notification_email(user)
    @user = user
    logg@care_home = care_home
    er.debug("Sending mail to #{@user.email} from #{ENV['NOREPLY']}")
    mail( :to => @user.email,
          :subject => 'You have a new slot' )
  end


  def verify_care_home(care_home, user)
    @care_home = care_home
    @user = user
    logger.debug("Sending mail to #{@user.email} from #{ENV['NOREPLY']}")
    mail( :to => @user.email,
          :subject => 'Please verify your Care Home' )
  end

  def slot_notification(staffing_response)
    @staffing_response = staffing_response
    @user = staffing_response.user
    logger.debug("Sending mail to #{@user.email} from #{ENV['NOREPLY']}")
    mail( :to => @user.email,
          :subject => 'New Slot Assigned' )
  end

  def slot_cancelled(staffing_response)
    @staffing_response = staffing_response
    @user = staffing_response.user
    logger.debug("Sending mail to #{@user.email} from #{ENV['NOREPLY']}")
    mail( :to => @user.email,
          :subject => 'Slot Cancelled' )
  end

  def slot_accepted(staffing_response)
    @staffing_response = staffing_response
    @user = staffing_response.user
    logger.debug("Sending mail to #{@user.email} from #{ENV['NOREPLY']}")
    mail( :to => @user.email,
          :subject => 'Slot Accepted' )
  end

  def care_home_verified(care_home)
    @care_home = care_home
    @user = care_home.users.first
    logger.debug("Sending mail to #{@user.email} from #{ENV['NOREPLY']}")
    mail( :to => @user.email,
          :subject => 'Care Home Verified' )

  end


  def no_slot_found(staffing_request)
    @staffing_request = staffing_request
    email = ENV["ADMIN_EMAIL"]
    logger.debug("Sending mail to #{email} from #{ENV['NOREPLY']}")
    mail( :to => email,
          :subject => "No slot found for request from #{staffing_request.care_home.name}" )

  end

  def slot_confirmation(staffing_response)
    @staffing_response = staffing_response
    @user = staffing_response.user
    logger.debug("Sending mail to #{@user.email} from #{ENV['NOREPLY']}")
    mail( :to => @user.email,
          :subject => 'Slot Confirmation' )
  end

end
