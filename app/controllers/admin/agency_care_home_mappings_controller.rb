module Admin
  class AgencyCareHomeMappingsController < Admin::ApplicationController
    def index
      if params[:search].present?
        search(AgencyCareHomeMapping)
      else
        super
      end
    end
  end
end
