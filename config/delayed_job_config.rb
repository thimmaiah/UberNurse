Delayed::Worker.destroy_failed_jobs = false
Delayed::Worker.sleep_delay = 60
Delayed::Worker.max_attempts = 3
Delayed::Worker.max_run_time = 5.minutes
Delayed::Worker.read_ahead = 10
Delayed::Worker.default_queue_name = 'default'
Delayed::Worker.delay_jobs = !Rails.env.test?
Delayed::Worker.raise_signal_exceptions = :term
Delayed::Worker.logger = Logger.new(File.join(Rails.root, 'log', 'delayed_job.log'))

# Chain delayed job's handle_failed_job method to do exception notification
Delayed::Worker.class_eval do
  def handle_failed_job_with_notification(job, error)
    handle_failed_job_without_notification(job, error)
    # rescue if ExceptionNotifier fails for some reason
    begin
      ExceptionNotifier.notify_exception(error)  if job.attempts == job.max_attempts
    rescue Exception => e
      Rails.logger.error "ExceptionNotifier failed: #{e.class.name}: #{e.message}"
      e.backtrace.each do |f|
        Rails.logger.error "  #{f}"
      end
      Rails.logger.flush
    end
  end
  alias_method_chain :handle_failed_job, :notification
end
