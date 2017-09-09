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

  def doc_not_available(user_doc_id)
    @user_doc = UserDoc.find(user_doc_id)
    @user = @user_doc.user
    logger.debug("Sending mail to #{ENV['NOREPLY']}")
    mail( :to => ENV['ADMIN_EMAIL'],
          :subject => "DBS not available for #{@user.first_name} #{@user.last_name}" )
  end

  def user_docs_uploaded(user)
    @user = user
    logger.debug("Sending mail to #{ENV['NOREPLY']}")
    mail( :to => ENV['ADMIN_EMAIL'],
          :subject => "#{@user.first_name} #{@user.last_name} has uploaded all docs" )
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
    @shift = shift
    @user = shift.user
    logger.debug("Sending mail to #{@user.email} from #{ENV['NOREPLY']}")
    mail( :to => @user.email,
          :subject => "New Shift Available: #{@shift.staffing_request.start_date.to_s(:custom_datetime)}" )
  end


  def shift_started(shift)
    @shift = shift
    @user = shift.user
    logger.debug("Sending mail to #{@user.email} from #{ENV['NOREPLY']}")
    mail( :to => @user.email,
          :cc => @shift.staffing_request.user.email,
          :subject => "Shift Started: #{@shift.start_date.to_s(:custom_datetime)} ")
  end

  def shift_ended(shift)
    @shift = shift
    @user = shift.user
    logger.debug("Sending mail to #{@user.email} from #{ENV['NOREPLY']}")
    mail( :to => @user.email,
          :cc => @shift.staffing_request.user.email,
          :subject => "Shift Ended: #{shift.end_date.to_s(:custom_datetime)}" )
  end


  def shift_cancelled(shift)
    @shift = shift
    @user = shift.user
    logger.debug("Sending mail to #{@user.email} from #{ENV['NOREPLY']}")
    mail( :to => @user.email,
          :cc => @shift.staffing_request.user.email,
          :subject => "Shift Cancelled: #{@shift.staffing_request.start_date.to_s(:custom_datetime)}" )
  end

  def shift_accepted(shift)
    @shift = shift
    @user = shift.user
    logger.debug("Sending mail to #{@user.email} from #{ENV['NOREPLY']}")
    mail( :to => @user.email, :cc=>@shift.user.email,
          :subject => "Shift Confirmed: #{shift.staffing_request.start_date.to_s(:custom_datetime)}" )
  end

  def care_home_verified(care_home)
    @care_home = care_home
    @user = care_home.users.first
    if(@user)
      logger.debug("Sending mail to #{@user.email} from #{ENV['NOREPLY']}")
      mail( :to => @user.email,
            :subject => 'Care Home Verified' )
    end
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

  def request_cancelled(staffing_request)
    @staffing_request = staffing_request
    email = @staffing_request.user.email
    logger.debug("Sending mail to #{email} from #{ENV['NOREPLY']}")
    mail( :to => email,
          :subject => "Request Cancelled" )

  end


end
