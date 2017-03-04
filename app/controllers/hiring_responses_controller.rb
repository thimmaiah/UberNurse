class HiringResponsesController < ApplicationController
  before_action :set_hiring_response, only: [:show, :update, :destroy]

  # GET /hiring_responses
  def index
    @hiring_responses = HiringResponse.all

    render json: @hiring_responses
  end

  # GET /hiring_responses/1
  def show
    render json: @hiring_response
  end

  # POST /hiring_responses
  def create
    @hiring_response = HiringResponse.new(hiring_response_params)

    if @hiring_response.save
      render json: @hiring_response, status: :created, location: @hiring_response
    else
      render json: @hiring_response.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /hiring_responses/1
  def update
    if @hiring_response.update(hiring_response_params)
      render json: @hiring_response
    else
      render json: @hiring_response.errors, status: :unprocessable_entity
    end
  end

  # DELETE /hiring_responses/1
  def destroy
    @hiring_response.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_hiring_response
      @hiring_response = HiringResponse.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def hiring_response_params
      params.require(:hiring_response).permit(:user_id, :hiring_request_id, :notest)
    end
end
