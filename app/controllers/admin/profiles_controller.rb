module Admin
  class ProfilesController < Admin::ApplicationController
    def new   
      resource = Profile.new(user_id: params[:user_id])
      render locals: {
          page: Administrate::Page::Form.new(dashboard, resource),
      }
    end
  end
end
