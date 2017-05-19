class HospitalsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource param_method: :hospital_params, except: [:create]

  # GET /hospitals
  def index
    render json: @hospitals
  end

  # GET /hospitals/1
  def show
    render json: @hospital
  end

  # POST /hospitals
  def create
    @hospital = Hospital.new(hospital_params)

    if @hospital.save
      # We need to ensure that the user becomes the hospital admin when it is created
      if(@current_user.role == "Admin")
        @current_user.hospital_id = @hospital.id
        @current_user.save
      end
      render json: @hospital, status: :created, location: @hospital
    else
      render json: @hospital.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /hospitals/1
  def update
    if @hospital.update(hospital_params)
      render json: @hospital
    else
      render json: @hospital.errors, status: :unprocessable_entity
    end
  end

  # DELETE /hospitals/1
  def destroy
    @hospital.destroy
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_hospital
    @hospital = Hospital.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def hospital_params
    params.require(:hospital).permit(:name, :address, :town, :postcode, :base_rate, :image_url)
  end
end
