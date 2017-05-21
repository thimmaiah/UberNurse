module Admin

  class PaymentsExportController < Admin::ApplicationController

    before_action :authenticate_user!
    
    def index
      @payments = Payment.all.includes(:user, :hospital, :staffing_request)

      if(params[:hospital_id].present?)
        @payments = @payments.where(hospital_id: params[:hospital_id])
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

end