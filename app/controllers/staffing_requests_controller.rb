class StaffingRequestsController < ApplicationController
  before_action :set_staffing_request, only: [:show, :update, :destroy]

  # GET /staffing_requests
  def index
    @staffing_requests = StaffingRequest.all.includes(:user, :hospital)

    render json: @staffing_requests, include: "user,hospital"
  end

  # GET /staffing_requests/1
  def show
    render json: @staffing_request
  end

  # POST /staffing_requests
  def create
    @staffing_request = StaffingRequest.new(staffing_request_params)

    if @staffing_request.save
      render json: @staffing_request, status: :created, location: @staffing_request
    else
      render json: @staffing_request.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /staffing_requests/1
  def update
    if @staffing_request.update(staffing_request_params)
      render json: @staffing_request
    else
      render json: @staffing_request.errors, status: :unprocessable_entity
    end
  end

  # DELETE /staffing_requests/1
  def destroy
    @staffing_request.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_staffing_request
      @staffing_request = StaffingRequest.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def staffing_request_params
      params.require(:staffing_request).permit(:hospital_id, :user_id, :start_date, :end_date, :rate_per_hour, :request_status, :auto_deny_in, :response_count, :payment_status)
    end
end
