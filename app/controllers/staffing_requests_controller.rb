class StaffingRequestsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource param_method: :staffing_request_params

  # GET /staffing_requests
  def index
    @per_page = 100
    @staffing_requests = StaffingRequest.where(care_home_id: current_user.care_home_ids) if !@staffing_requests
    @staffing_requests = @staffing_requests.open.order("start_date asc").page(@page).per(@per_page)
    render json: @staffing_requests.includes(:user, :care_home, :shifts), include: "user,care_home"
  end

  def price
    @staffing_request = StaffingRequest.new(staffing_request_params)
    @staffing_request.user_id = current_user.id
    @staffing_request.care_home_id = current_user.care_home_id
    @staffing_request.created_at = Time.now if !@staffing_request.created_at

    Rate.price_estimate(@staffing_request)
    render json: @staffing_request
  end


  # GET /staffing_requests/1
  def show
    render json: @staffing_request, include: "shifts"
  end


  # POST /staffing_requests
  def create
    @staffing_request = StaffingRequest.new(staffing_request_params)
    @staffing_request.user_id = current_user.id
    # Sometimes we get requests with care home - where 1 person manages multiple care homes
    if(@staffing_request.care_home_id)
      # Make sure we can book a req for this care home, if its not a sister care home - deny access
      raise CanCan::AccessDenied unless current_user.belongs_to_care_home(@staffing_request.care_home_id)
    else
      @staffing_request.care_home_id = current_user.care_home_id
    end

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
    @staffing_request.request_status = "Cancelled"
    @staffing_request.save
    UserNotifierMailer.request_cancelled(@staffing_request).deliver_later      
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_staffing_request
    @staffing_request = StaffingRequest.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def staffing_request_params
    # Ensure Start end times are stripped of any TZ - its always Lon time
    start_date = params[:staffing_request][:start_date].split("+")[0]
    end_date = params[:staffing_request][:end_date].split("+")[0]
    params[:staffing_request][:start_date] = start_date
    params[:staffing_request][:end_date] = end_date

    params.require(:staffing_request).permit(:care_home_id, :user_id, :start_date, :manual_assignment_flag, :notes,
                                             :end_date, :rate_per_hour, :request_status, :auto_deny_in, :response_count,
                                             :payment_status, :start_code, :end_code, :price, :role, :speciality,
                                             :pricing_audit=>[:hours_worked, :base_rate, :base_price, :factor_value, :factor_name, :price]
                                             )
  end
end
