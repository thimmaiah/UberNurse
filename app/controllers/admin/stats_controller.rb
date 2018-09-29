module Admin
  class StatsController < Admin::ApplicationController
   
   def index
      if params[:search].present?
        search(Stat)
      else
        super
        @resources = Stat.page(params[:page]).per(10)
      end
    end

    def valid_action?(name, resource = resource_class)
      %w[edit destroy].exclude?(name.to_s) && super
    end


  end
end
