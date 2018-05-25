# All Administrate controllers inherit from this `Admin::ApplicationController`,
# making it the ideal place to put authentication logic or other
# before_actions.
#
# If you want to add pagination or other controller-level concerns,
# you're free to overwrite the RESTful controller actions.
module Admin
  class ApplicationController < Administrate::ApplicationController
    before_action :authenticate_user!
    before_action :check_admin

    def check_admin
      if current_user && current_user.role == "Super User"
        return true
      else
        return false
      end
    end

    def setup_search
      page = Administrate::Page::Collection.new(dashboard, order: order)

      render locals: {
        resources: @resources,
        search_term: params[:search],
        page: page,
        show_search_bar: true
      }
    end

    def show_search_bar?
      true
    end
    # Override this value to specify the number of elements to display at a time
    # on index pages. Defaults to 20.
    # def records_per_page
    #   params[:per_page] || 20
    # end

    def search(entity)
      with = params[:with].present? ? eval("{"+params[:with].gsub(/ ?= ?/,":")+"}") : {}
      if params[:search] == "*"
        @resources = entity.search( with: with ).page(params[:page]).per(10)
      else
        @resources = entity.search( params[:search], with: with ).page(params[:page]).per(10)
      end
      setup_search
    end
  end
end
