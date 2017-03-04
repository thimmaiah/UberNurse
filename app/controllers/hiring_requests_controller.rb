class HiringRequestsController < ApplicationController
  before_action :set_hiring_request, only: [:show, :update, :destroy]

  # GET /hiring_requests
  def index
    @hiring_requests = HiringRequest.all

    render json: @hiring_requests
  end

  # GET /hiring_requests/1
  def show
    render json: @hiring_request
  end

  # POST /hiring_requests
  def create
    @hiring_request = HiringRequest.new(hiring_request_params)

    if @hiring_request.save
      render json: @hiring_request, status: :created, location: @hiring_request
    else
      render json: @hiring_request.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /hiring_requests/1
  def update
    if @hiring_request.update(hiring_request_params)
      render json: @hiring_request
    else
      render json: @hiring_request.errors, status: :unprocessable_entity
    end
  end

  # DELETE /hiring_requests/1
  def destroy
    @hiring_request.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_hiring_request
      @hiring_request = HiringRequest.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def hiring_request_params
      params.require(:hiring_request).permit(:start_date, :start_time, :end_date, :num_of_hours, :rate, :req_type, :user_id, :hospital_id)
    end
end
