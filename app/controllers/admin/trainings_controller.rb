module Admin
  class TrainingsController < Admin::ApplicationController
    def new   
      resource = Training.new(user_id: params[:user_id], profile_id: params[:profile_id])
      render locals: {
          page: Administrate::Page::Form.new(dashboard, resource),
      }
    end
  end
end
