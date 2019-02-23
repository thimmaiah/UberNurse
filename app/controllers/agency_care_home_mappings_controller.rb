class AgencyCareHomeMappingsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource param_method: :agency_care_home_mapping_params, except: [:create]

  respond_to :html, :json

  def index
    @agency_care_home_mappings = AgencyCareHomeMapping.all
    respond_with(@agency_care_home_mappings)
  end

  def show
    respond_with(@agency_care_home_mapping)
  end

  def new
    @agency_care_home_mapping = AgencyCareHomeMapping.new
    respond_with(@agency_care_home_mapping)
  end

  def edit
  end

  def create
    @agency_care_home_mapping = AgencyCareHomeMapping.new(agency_care_home_mapping_params)
    @agency_care_home_mapping.save
    respond_with(@agency_care_home_mapping)
  end

  def update
    @agency_care_home_mapping.update(agency_care_home_mapping_params)
    respond_with(@agency_care_home_mapping)
  end

  def destroy
    @agency_care_home_mapping.destroy
    respond_with(@agency_care_home_mapping)
  end

  private
    def set_agency_care_home_mapping
      @agency_care_home_mapping = AgencyCareHomeMapping.find(params[:id])
    end

    def agency_care_home_mapping_params
      params.require(:agency_care_home_mapping).permit(:agency_id, :care_home_id)
    end
end
