module Admin
  class AgencyUserMappingsController < Admin::ApplicationController
    
    def index
      if params[:search].present?
        search(AgencyUserMapping)
      else
        resources, search_term = setup_index(params)
        resources = resources.includes(:user, :agency)

        page = Administrate::Page::Collection.new(dashboard, order: order)

        render locals: {
          resources: resources,
          search_term: search_term,
          page: page,
          show_search_bar: show_search_bar?,
        }
      end
    end

    def create_from_user
      if params[:email].present?
        u = User.find_by_email(params[:email])

        if(u)
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
          flash[:alert] = "Could not save user mapping. User with #{params[:email]} not found"
        end

      else
        flash[:alert] = "Email not specified"
      end
      redirect_to admin_agency_user_mappings_path    	
    end

  end
end
