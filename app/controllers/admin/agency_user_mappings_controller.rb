module Admin
  class AgencyUserMappingsController < Admin::ApplicationController
    def index
      if params[:search].present?
        search(AgencyUserMapping)
      else
        super
      end
    end
  end
end
