module Admin
  class AgencyCareHomeMappingsController < Admin::ApplicationController
    
    def index
      if params[:search].present?
        search(AgencyCareHomeMapping)
      else
        super
      end
    end

    def create_from_care_home
      if params[:phone].present?
        c = CareHome.find_by_phone(params[:phone])

        acm = AgencyCareHomeMapping.where(care_home_id: c.id, agency_id: current_user.agency_id).first

        if acm
          flash[:success] = "CareHome already mapped to this agency"
        else
          acm = AgencyCareHomeMapping.new(care_home_id: c.id, agency_id: current_user.agency_id, verified:false)
          if acm.save
            flash[:success] = "Saved CareHome mapping successfully"
          else
            flash[:alert] = "Could not save CareHome mapping. #{acm.errors}"
          end
        end
      else
        flash[:alert] = "Phone not specified"
      end
      redirect_to admin_agency_care_home_mappings_path    	
    end

  end
end
