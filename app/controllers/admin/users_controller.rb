module Admin
  class UsersController < Admin::ApplicationController
    
    before_action :authenticate_user!

    def index
      if params[:search].present?        
        search(User)
      else
        super  
        @resources = User.page(params[:page]).per(10)
        if(params[:created_at] == 'today')
          @resources = @resources.where("created_at >= ?", Date.today)
        end
      end
    end

    def export
      start_date = params[:created_at_start]
      end_date = params[:created_at_end]
      logger.debug "roles = #{params[:roles]}"
      @resources = User.where("created_at >= ? and created_at <= ?", start_date, end_date)
      @resources = @resources.where(role: params[:roles]) if params[:roles].present?
    end

    def export_form
    end

    # Define a custom finder by overriding the `find_resource` method:
    # def find_resource(param)
    #   User.find_by!(slug: param)
    # end

    # See https://administrate-prototype.herokuapp.com/customizing_controller_actions
    # for more information
    def destroy
      @resource = User.find(params[:id])
      @resource.really_destroy!
      redirect_to action: :index
    end
  end
end
