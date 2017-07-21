# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

Time::DATE_FORMATS[:custom_datetime] = "%d/%m/%Y  %H:%M"

ActionMailer::Base.register_interceptor(UnsubscribedInterceptor)

# ActionMailer::Base.smtp_settings = {
#   :user_name => 'apikey',
#   :password => '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',
#   :domain => 'connuct.co.uk',
#   :address => 'smtp.sendgrid.net',
#   :port => 587,
#   :authentication => :plain,
#   :enable_starttls_auto => true
# }