class UserNotifierMailer < ApplicationMailer

  def reference_notification(reference)
    logger.debug("Sending mail to #{reference.email}")
    attachments["Reference Request"] = File.read("#{Rails.root}/public/system/Reference_Request_to_employer_V3.doc")
    @user = reference.user
    @reference = reference
    mail( :to => reference.email, :bcc => ENV['ADMIN_EMAIL'],
          :subject => "Reference Request for: #{@user.first_name} #{@user.last_name}" )
  
  end

  def delete_requested(user_id)
    @user = User.find(user_id)
    logger.debug("Sending mail to #{ENV['NOREPLY']}")
    mail( :to => ENV['ADMIN_EMAIL'],
          :subject => "User requested deletion of personal data: #{@user.first_name} #{@user.last_name}" )
  end

  def request_verification(user_doc_id)
    @user_doc = UserDoc.find(user_doc_id)
    logger.debug("Sending mail to #{ENV['ADMIN_EMAIL']} from #{ENV['NOREPLY']}")
    mail( :to => ENV['ADMIN_EMAIL'],
          :subject => 'Document Verification Required.' )
  end

  def verification_complete(agency_user_mapping_id)
    @acm = AgencyUserMapping.find(agency_user_mapping_id)
    @user = @acm.user
    @agency = @acm.agency
    logger.debug("Sending mail to #{@user.email} from #{ENV['NOREPLY']}")
    mail( :to => @user.email,
          :bcc => ENV['ADMIN_EMAIL'],
          :subject => 'Verification Completed.' )
  end

  def doc_refresh_notification(user_doc)
    @user = user_doc.user
    @user_doc = user_doc
    logger.debug("Sending mail to #{@user.email} from #{ENV['NOREPLY']}")
    mail( :to => @user.email,
          :subject => "Please upload latest document: #{user_doc.doc_type}" )
  end

  def training_refresh_notification(training)
    @user = training.user
    @training = training
    logger.debug("Sending mail to #{@user.email} from #{ENV['NOREPLY']}")
    mail( :to => @user.email,
          :subject => "Training will expire: #{training.name}" )
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

    # Send this to all the agencies who have this user as a carer
    agency_emails = []
    @user.agencies.each do |a|
      agency_emails += a.users.collect(&:email)
    end

    bcc = agency_emails.join(",")

    logger.debug("Sending mail to #{ENV['NOREPLY']}")
    mail( :to => ENV['ADMIN_EMAIL'],
          :bcc => agency_emails,
          :subject => "#{@user.first_name} #{@user.last_name} has uploaded all docs" )
  end


  def staffing_request_created(staffing_request)
    @staffing_request = staffing_request
    @agency = staffing_request.agency
    email = ENV['ADMIN_EMAIL']
    logger.debug("Sending mail to #{email} from #{ENV['NOREPLY']}")

    subject = staffing_request.manual_assignment_flag ? "Manual assignment required: New request from #{staffing_request.care_home.name}" : "New request from #{staffing_request.care_home.name}"
    mail( :to => email,
          :subject => subject )

  end


  def care_home_verified(acm_id)
    @acm = AgencyCareHomeMapping.find(acm_id)
    @care_home = @acm.care_home
    @agency = @acm.agency
    @user = @care_home.users.first
    if(@care_home)
      logger.debug("Sending mail to #{@care_home.emails} from #{ENV['NOREPLY']}")
      mail( :to => @care_home.emails,
            :bcc => ENV['ADMIN_EMAIL'] + "," + @agency.broadcast_group,
            :subject => 'Care Home Verified' )
    end
  end


  def request_cancelled(staffing_request)
    @staffing_request = staffing_request
    @agency = staffing_request.agency
    email = @staffing_request.user.email
    logger.debug("Sending mail to #{email} from #{ENV['NOREPLY']}")
    mail( :to => email, :bcc => ENV['ADMIN_EMAIL'] + "," + @agency.broadcast_group,
          :subject => "Request Cancelled: #{@staffing_request.start_date.to_s(:custom_datetime)}" )

  end

  def user_accept_agency_notification(aum)
    @user = aum.user
    @agency = aum.agency
    logger.debug("Sending mail to #{@user.email} from #{ENV['NOREPLY']}")
    mail( :to => @user.email, :bcc => ENV['ADMIN_EMAIL'],
          :subject => "Accept Agency: #{@agency.name}" )

  end

  def care_home_accept_agency_notification(acm)
    @care_home = acm.care_home
    @agency = acm.agency

    logger.debug("Sending mail to #{@care_home. emails} from #{ENV['NOREPLY']}")
    mail( :to => @care_home.emails, :bcc => ENV['ADMIN_EMAIL'],
          :subject => "Accept Agency: #{@agency.name}" )

  end

  layout :select_layout


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
    
    emails = @care_home.emails

    logger.debug("Sending mail to #{emails} from #{ENV['NOREPLY']}")
    mail( :to => emails,
          :subject => "Care Home QR Code: #{Date.today}" )
  
  end


  private
  def select_layout
    if action_name == 'care_home_qr_code'
      false
    else
      'mailer'
    end
  end
end
