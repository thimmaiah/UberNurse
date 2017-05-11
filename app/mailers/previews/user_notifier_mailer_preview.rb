class UserNotifierMailerPreview < ActionMailer::Preview
  def user_notification_email
    UserNotifierMailer.user_notification_email(User.first)
  end
end