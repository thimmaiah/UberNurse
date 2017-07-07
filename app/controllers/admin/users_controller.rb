module Admin
  class UsersController < Admin::ApplicationController
    # To customize the behavior of this controller,
    # you can overwrite any of the RESTful actions. For example:
    #
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

    # Define a custom finder by overriding the `find_resource` method:
    # def find_resource(param)
    #   User.find_by!(slug: param)
    # end

    # See https://administrate-prototype.herokuapp.com/customizing_controller_actions
    # for more information
  end
end
