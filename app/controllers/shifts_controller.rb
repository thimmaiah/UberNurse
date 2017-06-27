class ShiftsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource param_method: :shift_params

  # GET /shifts
  def index
    if (params[:staffing_request_id].present?)
        @shifts = @shifts.where(staffing_request_id: params[:staffing_request_id])
    end

    if(params[:response_status].present?)
      @shifts = @shifts.where(response_status: params[:response_status])
    else
      @shifts = @shifts.open
    end

    @shifts = @shifts.order("id desc").page(@page).per(@per_page)
    render json: @shifts.includes(:staffing_request, :care_home, :user=>:profile_pic), each_serializer: ShiftMiniSerializer

  end

  # GET /shifts/1
  def show

    if(current_user.id == @shift.user_id && !@shift.viewed)
      # Mark this as viewed if the care giver assigned, has seen it
      @shift.viewed = true 
      @shift.save
    end
    
    render json: @shift
  end

  # POST /shifts
  def create
    @shift = Shift.new(shift_params)
    @shift.user_id = current_user.id

    if @shift.save
      render json: @shift, status: :created, location: @shift
    else
      render json: @shift.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /shifts/1
  def update
    if @shift.update(shift_params)
      render json: @shift
    else
      render json: @shift.errors, status: :unprocessable_entity
    end
  end

  # DELETE /shifts/1
  def destroy
    @shift.response_status = "Cancelled"
    @shift.save
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_shift
      @shift = Shift.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def shift_params
      params.require(:shift).permit(:staffing_request_id, :user_id, :start_code, 
        :end_code, :response_status, :accepted, :rated, :care_home_id, :payment_status)
    end
end
