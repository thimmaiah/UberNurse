class UserNotifierMailer < ApplicationMailer

  # send a signup email to the user, pass in the user object that   contains the user's email address
  def user_notification_email(user)
    @user = user
    @care_home = care_home
    logger.debug("Sending mail to #{@user.email} from #{ENV['NOREPLY']}")
    mail( :to => @user.email,
          :subject => 'You have a new shift' )
  end

  def request_verification(user_doc_id)
    @user_doc = UserDoc.find(user_doc_id)
    logger.debug("Sending mail to #{ENV['ADMIN_EMAIL']} from #{ENV['NOREPLY']}")
    mail( :to => ENV['ADMIN_EMAIL'],
          :subject => 'Document Verification Required.' )
  end

  def verification_complete(user_id)
    @user = User.find(user_id)
    logger.debug("Sending mail to #{@user.email} from #{ENV['NOREPLY']}")
    mail( :to => @user.email,
          :subject => 'Verification Completed.' )
  end

  def doc_refresh_notification(user)
    @user = user
    logger.debug("Sending mail to #{@user.email} from #{ENV['NOREPLY']}")
    mail( :to => @user.email,
          :subject => 'Please upload latest documents' )
  end

  def verification_reminder(user)
    @user = user
    logger.debug("Sending mail to #{@user.email} from #{ENV['NOREPLY']}")
    mail( :to => @user.email,
          :subject => 'Please verify your account on Care Connect' )
  end


  def verify_care_home(care_home, user)
    @care_home = care_home
    @user = user
    logger.debug("Sending mail to #{@user.email} from #{ENV['NOREPLY']}")
    mail( :to => @user.email,
          :subject => 'Please verify your Care Home' )
  end

  def shift_notification(shift)
    raise "Dumb error"
    @shift = shift
    @user = shift.user
    logger.debug("Sending mail to #{@user.email} from #{ENV['NOREPLY']}")
    mail( :to => @user.email,
          :subject => 'New Shift Available' )
  end

  def shift_cancelled(shift)
    @shift = shift
    @user = shift.user
    logger.debug("Sending mail to #{@user.email} from #{ENV['NOREPLY']}")
    mail( :to => @user.email,
          :subject => 'Shift Cancelled' )
  end

  def shift_accepted(shift)
    @shift = shift
    @user = shift.user
    logger.debug("Sending mail to #{@user.email} from #{ENV['NOREPLY']}")
    mail( :to => @user.email, :cc=>@shift.user.email,
          :subject => 'Shift Confirmed' )
  end

  def care_home_verified(care_home)
    @care_home = care_home
    @user = care_home.users.first
    logger.debug("Sending mail to #{@user.email} from #{ENV['NOREPLY']}")
    mail( :to => @user.email,
          :subject => 'Care Home Verified' )

  end


  def no_shift_found(staffing_request)
    @staffing_request = staffing_request
    email = ENV["ADMIN_EMAIL"]
    logger.debug("Sending mail to #{email} from #{ENV['NOREPLY']}")
    mail( :to => email,
          :subject => "No shift found for request from #{staffing_request.care_home.name}" )

  end

  def shift_confirmation(shift)
    @shift = shift
    @user = shift.user
    logger.debug("Sending mail to #{@user.email} from #{ENV['NOREPLY']}")
    mail( :to => @user.email,
          :subject => 'Shift Confirmation' )
  end

end
