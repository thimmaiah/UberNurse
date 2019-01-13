module Admin
  class UsersController < Admin::ApplicationController
    
    before_action :authenticate_user!

    def index
      if params[:search].present?        
        search(User)
      else
        super  
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


    def update
      if params[:user][:password].blank?
        params[:user].delete(:password)
        params[:user].delete(:password_confirmation)
      end
      super
    end
    
    def destroy
      @resource = User.find(params[:id])
      @resource.really_destroy!
      redirect_to action: :index
    end

    def profile            
      @resource = User.find(params[:id])      
      render "profile", locals: {
        page: Administrate::Page::Form.new(dashboard, @resource)
      }
    end

  end
end
