module Admin

  class PaymentsExportController < Admin::ApplicationController

    before_action :authenticate_user!

    def index
      @payments = Payment.all.includes(:user, :care_home, :staffing_request, :agency)

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

      if(current_user.agency_id.present?)
        @payments = @payments.where(agency_id: current_user.agency_id)
      end

      case params[:report_format]
      when "Carer"
        template ="carer"
      when "Care Home"
        template = "care_home"
        @payments = @payments.where("care_home_id is not null")
      when "Both"
        template = "both"
      end

      logger.info "################## #{params[:report_format]}, #{template}"
      render xlsx: "admin/payments_export/#{template}"
    end
  end

  def form
    render "form"
  end

end
