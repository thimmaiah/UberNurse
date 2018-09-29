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
  end
end
