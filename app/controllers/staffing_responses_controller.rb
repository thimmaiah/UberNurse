class StaffingResponsesController < ApplicationController
  before_action :authenticate_user!  
  before_action :set_staffing_response, only: [:show, :update, :destroy]

  # GET /staffing_responses
  def index
    @staffing_responses = StaffingResponse.all.includes(:user)

    render json: @staffing_responses, include: "user"
  end

  # GET /staffing_responses/1
  def show
    render json: @staffing_response
  end

  # POST /staffing_responses
  def create
    @staffing_response = StaffingResponse.new(staffing_response_params)

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
      params.require(:staffing_response).permit(:staffing_request_id, :user_id, :start_code, :end_code, :response_status, :accepted, :rated)
    end
end
