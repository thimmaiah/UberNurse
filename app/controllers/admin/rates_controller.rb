module Admin
  class RatesController < Admin::ApplicationController

    before_action :authenticate_user!
    load_and_authorize_resource
    
    def index
      search_term = params[:search].to_s.strip
        
      resources = @rates.page(params[:page]).per(records_per_page)
      page = Administrate::Page::Collection.new(dashboard, order: order)

      render locals: {
        resources: resources,
        search_term: search_term,
        page: page,
        show_search_bar: show_search_bar?,
      }

    end

  end
end
