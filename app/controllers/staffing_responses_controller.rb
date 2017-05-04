class StaffingResponsesController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource param_method: :staffing_response_params

  # GET /staffing_responses
  def index
    if (params[:staffing_request_id].present?)
        @staffing_responses = @staffing_responses.where(staffing_request_id: params[:staffing_request_id])
        @staffing_responses = @staffing_responses.where(hospital_id: current_user.hospital_id)
    end
    render json: @staffing_responses.includes(:user), include: "user"
  end

  # GET /staffing_responses/1
  def show
    render json: @staffing_response
  end

  # POST /staffing_responses
  def create
    @staffing_response = StaffingResponse.new(staffing_response_params)
    @staffing_response.user_id = current_user.id

    if @staffing_response.save
      render json: @staffing_response, status: :created, location: @staffing_response
    else
      render json: @staffing_response.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /staffing_responses/1
  def update
    if @staffing_response.update(staffing_response_params)
      render json: @staffing_response
    else
      render json: @staffing_response.errors, status: :unprocessable_entity
    end
  end

  # DELETE /staffing_responses/1
  def destroy
    @staffing_response.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_staffing_response
      @staffing_response = StaffingResponse.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def staffing_response_params
      params.require(:staffing_response).permit(:staffing_request_id, :user_id, :start_code, 
        :end_code, :response_status, :accepted, :rated, :hospital_id, :payment_status)
    end
end
