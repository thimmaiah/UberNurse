class RecurringRequestsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource param_method: :recurring_request_params, except: [:create]

  respond_to :json

  def index
    @per_page = 10
    @recurring_requests = RecurringRequest.where(care_home_id: current_user.care_home_ids) if !@recurring_requests
    @recurring_requests = @recurring_requests.order("recurring_requests.start_date asc").page(@page).per(@per_page)
    
    render json:  @recurring_requests.includes(:agency, :care_home, :user)
  end

  def get_carers
    @recurring_request = RecurringRequest.new(recurring_request_params)
    agency_carers = @recurring_request.care_home.carers.merge(CareHomeCarerMapping.agency_filter(@recurring_request.agency_id))
    render json: agency_carers.where(role: @recurring_request.role, pause_shifts: false), each_serializer: UserMiniSerializer
  end


  def show
    respond_with(@recurring_request)
  end

  def new
    @recurring_request = RecurringRequest.new
    respond_with(@recurring_request)
  end

  def edit
  end

  def create
    @recurring_request = RecurringRequest.new(recurring_request_params)
    @recurring_request.user_id = current_user.id
    @recurring_request.save
    respond_with(@recurring_request)
  end

  def update
    @recurring_request.update(recurring_request_params)
    respond_with(@recurring_request)
  end

  def destroy
    @recurring_request.destroy
    respond_with(@recurring_request)
  end

  private
    def set_recurring_request
      @recurring_request = RecurringRequest.find(params[:id])
    end

    def recurring_request_params
      params.require(:recurring_request).permit(:care_home_id, :user_id, :start_date, :end_date, :role, 
        :speciality, :on, :start_on, :end_on, :audit, {dates:[]}, :notes, :agency_id, :preferred_carer_id)
    end
end
