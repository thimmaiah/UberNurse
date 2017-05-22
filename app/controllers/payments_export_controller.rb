
  class PaymentsExportController < ActionController::Base

    # Devise stuff
    include DeviseTokenAuth::Concerns::SetUserByToken

    # Authorization
    include CanCan::ControllerAdditions
    include ActionController::MimeResponds

    before_action :authenticate_user!
    load_and_authorize_resource param_method: :payment_params

    def index
      @payments = Payment.all.includes(:user, :care_home, :staffing_request)

      if(params[:care_home_id].present?)
        @payments = @payments.where(care_home_id: params[:care_home_id])
      end

      if(params[:user_id].present?)
        @payments = @payments.where(user_id: params[:user_id])
      end

      if(params[:created_at_start].present?)
        @payments = @payments.where("created_at >= ?", params[:created_at_start])
      end

      if(params[:created_at_end].present?)
        @payments = @payments.where("created_at <= ?", params[:created_at_end])
      end

      render xls: "index"
    end
  end

