require 'rails_helper'

RSpec.describe "StaffingResponses", type: :request do
  describe "GET /staffing_responses" do
    it "works! (now write some real specs)" do
      get staffing_responses_path
      expect(response).to have_http_status(200)
    end
  end
end
