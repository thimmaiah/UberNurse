class RecurringRequestsController < ApplicationController
  before_action :set_recurring_request, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @recurring_requests = RecurringRequest.all
    respond_with(@recurring_requests)
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
      params.require(:recurring_request).permit(:care_home_id, :user_id, :start_date, :end_date, :role, :speciality, :on, :start_on, :end_on, :audit)
    end
end
