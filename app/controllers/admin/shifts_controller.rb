module Admin
  class ShiftsController < Admin::ApplicationController
    # To customize the behavior of this controller,
    # you can overwrite any of the RESTful actions. For example:
    #
    def index
      if params[:search].present?
        search(Shift)
      else
        super
        @resources = Shift.page(params[:page]).per(10)
      end
    end

  end
end
