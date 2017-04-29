class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  include CanCan::ControllerAdditions
  include ActionController::MimeResponds

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { head :forbidden, content_type: 'text/html' }
    end
  end


  before_action :prepare_exception_notifier
  private
  def prepare_exception_notifier
    request.env["exception_notifier.exception_data"] = {
      :current_user => current_user
    }
  end
  
end
