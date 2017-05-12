module Admin
  class StaffingResponsesController < Admin::ApplicationController
    # To customize the behavior of this controller,
    # you can overwrite any of the RESTful actions. For example:
    #
    def index
      if params[:search].present?
        
        @resources = StaffingResponse.search(params[:search]).page(params[:page]).per(10)
        setup_search

      else
        super
        @resources = StaffingResponse.page(params[:page]).per(10)
      end
    end

    # Define a custom finder by overriding the `find_resource` method:
    # def find_resource(param)
    #   StaffingResponse.find_by!(slug: param)
    # end

    # See https://administrate-prototype.herokuapp.com/customizing_controller_actions
    # for more information
  end
end
