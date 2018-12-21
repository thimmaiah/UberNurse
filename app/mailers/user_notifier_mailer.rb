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

  def staffing_request_created(staffing_request)
    @staffing_request = staffing_request
    email = ENV["ADMIN_EMAIL"]
    logger.debug("Sending mail to #{email} from #{ENV['NOREPLY']}")

    subject = staffing_request.manual_assignment_flag ? "Manual assignment required: New request from #{staffing_request.care_home.name}" : "New request from #{staffing_request.care_home.name}"
    mail( :to => email,
          :subject => subject )

  end

  def shift_notification(shift)
    @shift = shift
    @user = shift.user
    logger.debug("Sending mail to #{@user.email} from #{ENV['NOREPLY']}")
    mail( :to => @user.email,
          :bcc => ENV['ADMIN_EMAIL'],
          :subject => "New Shift Available: #{@shift.staffing_request.care_home.name} @ #{@shift.staffing_request.start_date.to_s(:custom_datetime)} : Notification #{shift.notification_count + 1}" )
  end


  def shift_started(shift)
    @shift = shift
    @user = shift.user
    logger.debug("Sending mail to #{@user.email} from #{ENV['NOREPLY']}")
    mail( :to => @user.email,
          :bcc => ENV['ADMIN_EMAIL'],
          :cc => @shift.staffing_request.user.email,
          :subject => "Shift Started: #{@shift.start_date.to_s(:custom_datetime)} ")
  end

  def shift_ended(shift)
    @shift = shift
    @user = shift.user
    logger.debug("Sending mail to #{@user.email} from #{ENV['NOREPLY']}")
    mail( :to => @user.email,
          :bcc => ENV['ADMIN_EMAIL'],
          :cc => @shift.staffing_request.user.email,
          :subject => "Shift Ended: #{shift.end_date.to_s(:custom_datetime)}" )
  end


  def shift_cancelled(shift)
    @shift = shift
    @user = shift.user
    logger.debug("Sending mail to #{@user.email} from #{ENV['NOREPLY']}")

    if (@shift.response_status == "Cancelled")
      # Notify only the shift user, Do NOT notify the staffing_request.user
      mail( :to => @user.email,
            :bcc => ENV['ADMIN_EMAIL'],
            :cc => @shift.staffing_request.user.email,
            :subject => "Shift Cancelled: #{@shift.user.first_name}: #{@shift.staffing_request.start_date.to_s(:custom_datetime)}" )
    else
      # Also notify the staffing_request.user
      mail( :to => @user.email,
            :bcc => ENV['ADMIN_EMAIL'],            
            :subject => "Shift #{@shift.response_status}: #{@shift.user.first_name}: #{@shift.staffing_request.start_date.to_s(:custom_datetime)}" )
    end
  end

  def shift_accepted(shift)
    @shift = shift
    @user = shift.user

    logger.debug("Sending mail to #{@user.email} from #{ENV['NOREPLY']}")
    
    mail( :to => @user.email, :bcc => ENV['ADMIN_EMAIL'],
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

  layout false, :only => 'care_home_qr_code'
  def care_home_qr_code(care_home)

    require 'rqrcode'

    @care_home = care_home

    qrcode = RQRCode::QRCode.new(@care_home.qr_code)
    png = qrcode.as_png(
          resize_gte_to: false,
          resize_exactly_to: false,
          fill: 'white',
          color: 'black',
          size: 360,
          border_modules: 4,
          module_px_size: 6,
          file: nil # path to write
          )
    File.open("#{Rails.root}/public/system/#{@care_home.qr_code.to_s}.png", 'wb') {|file| file.write(png.to_s) }
    
    emails = @care_home.users.collect(&:email).join(",")

    if(@care_home.care_home_broadcast_group)
      emails += ",#{@care_home.care_home_broadcast_group}"  
    end

    logger.debug("Sending mail to #{emails} from #{ENV['NOREPLY']}")
    mail( :to => emails,
          :subject => "Care Home QR Code: #{Date.today}" )
  
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
    mail( :to => @user.email, :bcc => ENV['ADMIN_EMAIL'],
          :subject => "Shift Reminder: #{@shift.staffing_request.care_home.name} @ #{shift.staffing_request.start_date.to_s(:custom_datetime)}" )
  end

  def send_codes_to_broadcast_group(shift)
    @shift = shift
    @user  = shift.user
    emails = @shift.staffing_request.user.email

    if(@shift.care_home.care_home_broadcast_group)
      emails += ",#{@shift.care_home.care_home_broadcast_group}"  
    end

    if @shift.care_home.sister_care_homes
      subject = "Shift Confirmed: #{shift.care_home.name}: #{shift.staffing_request.start_date.to_s(:custom_datetime)}: #{shift.user.first_name}: Start / End Codes"
    else
      subject = "Shift Confirmed: #{shift.staffing_request.start_date.to_s(:custom_datetime)}: #{shift.user.first_name}: Start / End Codes"
    end
    
    logger.debug("Sending mail to #{@shift.care_home.care_home_broadcast_group} from #{ENV['NOREPLY']}")
    mail( :to => emails, :bcc => ENV['ADMIN_EMAIL'],
            :subject => subject )

  end

  def request_cancelled(staffing_request)
    @staffing_request = staffing_request
    email = @staffing_request.user.email
    logger.debug("Sending mail to #{email} from #{ENV['NOREPLY']}")
    mail( :to => email, :bcc => ENV['ADMIN_EMAIL'],
          :subject => "Request Cancelled: #{@staffing_request.start_date.to_s(:custom_datetime)}" )

  end


end
