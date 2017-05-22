class UserNotifierMailer < ApplicationMailer

  # send a signup email to the user, pass in the user object that   contains the user's email address
  def user_notification_email(user)
    @user = user
    logger.debug("Sending mail to #{@user.email} from #{ENV['NOREPLY']}")
    mail( :to => @user.email,
          :subject => 'You have a new slot' )
  end


  def verify_care_home(user)
    @user = user
    logger.debug("Sending mail to #{@user.email} from #{ENV['NOREPLY']}")
    mail( :to => @user.email,
          :subject => 'Please verify your Care Home' )
  end

  def slot_notification(staffing_response)
    @user = staffing_response.user
    logger.debug("Sending mail to #{@user.email} from #{ENV['NOREPLY']}")
    mail( :to => @user.email,
          :subject => 'New Slot Assigned' )
  end

end
