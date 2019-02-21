module Admin
  class AgencyUserMappingsController < Admin::ApplicationController
    
    def index
      if params[:search].present?
        search(AgencyUserMapping)
      else
        super
      end
    end

    def create_from_user
      if params[:email].present?
        u = User.find_by_email(params[:email])

        aum = AgencyUserMapping.where(user_id: u.id, agency_id: current_user.agency_id).first

        if aum
          flash[:success] = "User already mapped to this agency"
        else
          aum = AgencyUserMapping.new(user_id: u.id, agency_id: current_user.agency_id, verified:false)
          if aum.save
            flash[:success] = "Saved user mapping successfully"
          else
            flash[:alert] = "Could not save user mapping. #{aum.errors}"
          end
        end
      else
        flash[:alert] = "Email not specified"
      end
      redirect_to admin_users_path    	
    end

  end
end
