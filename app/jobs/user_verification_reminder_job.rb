class UserVerificationReminderJob < ApplicationJob
  queue_as :default

  def perform
    User.temps.where("verified = false AND (verification_reminder is null OR verification_reminder < ?)", Time.now - 2.day).each do |user|
    	UserNotifierMailer.verification_reminder(user).deliver_now
    	user.verification_reminder = Time.now
    	user.save!    	
    end
  end
end
