class AgenciesController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource param_method: :agency_params, except: [:create]


  respond_to :html, :json

  def index
    @agencies = Agency.all
    respond_with(@agencies)
  end

  def show
    respond_with(@agency)
  end

  def new
    @agency = Agency.new
    respond_with(@agency)
  end

  def edit
  end

  def create
    @agency = Agency.new(agency_params)
    @agency.save
    respond_with(@agency)
  end

  def update
    @agency.update(agency_params)
    respond_with(@agency)
  end

  def destroy
    @agency.destroy
    respond_with(@agency)
  end

  private
    def set_agency
      @agency = Agency.find(params[:id])
    end

    def agency_params
      params.require(:agency).permit(:name, :address, :postcode, :phone, :broadcast_group)
    end
end
