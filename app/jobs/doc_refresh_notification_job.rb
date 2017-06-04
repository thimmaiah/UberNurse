class DocRefreshNotificationJob < ApplicationJob
  queue_as :default

  def perform
    User.temps.where("verified_on <= ?", Date.today - 1.year).each do |user|
    	UserNotifierMailer.doc_refresh_notification(user).deliver_now
    end
  end
end
