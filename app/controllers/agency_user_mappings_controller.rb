class AgencyUserMappingsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource param_method: :agency_user_mapping_params, except: [:create]

  respond_to :html, :json

  def index
    @agency_user_mappings = AgencyUserMapping.all
    respond_with(@agency_user_mappings)
  end

  def show
    respond_with(@agency_user_mapping)
  end

  def new
    @agency_user_mapping = AgencyUserMapping.new
    respond_with(@agency_user_mapping)
  end

  def edit
  end

  def create
    @agency_user_mapping = AgencyUserMapping.new(agency_user_mapping_params)
    @agency_user_mapping.save
    respond_with(@agency_user_mapping)
  end

  def update
    @agency_user_mapping.update(agency_user_mapping_params)
    respond_with(@agency_user_mapping)
  end

  def destroy
    @agency_user_mapping.destroy
    respond_with(@agency_user_mapping)
  end

  private
    def set_agency_user_mapping
      @agency_user_mapping = AgencyUserMapping.find(params[:id])
    end

    def agency_user_mapping_params
      params.require(:agency_user_mapping).permit(:agency_id, :user_id)
    end
end
