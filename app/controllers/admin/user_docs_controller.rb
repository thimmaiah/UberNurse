module Admin
  class UserDocsController < Admin::ApplicationController
    # To customize the behavior of this controller,
    # you can overwrite any of the RESTful actions. For example:
    #
    def index
      if params[:search].present?
        search(UserDoc)        
      else
        super
      end
    end

    def new 
      resource = UserDoc.new(user_id: params[:user_id])
      render locals: {
          page: Administrate::Page::Form.new(dashboard, resource),
      }
    end

    # Define a custom finder by overriding the `find_resource` method:
    # def find_resource(param)
    #   UserDoc.find_by!(slug: param)
    # end

    # See https://administrate-prototype.herokuapp.com/customizing_controller_actions
    # for more information
  end
end
