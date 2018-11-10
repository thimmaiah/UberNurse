require 'rails_helper'

RSpec.describe "agency_user_mappings/index", type: :view do
  before(:each) do
    assign(:agency_user_mappings, [
      AgencyUserMapping.create!(
        :user_id => 2,
        :agency_id => 3
      ),
      AgencyUserMapping.create!(
        :user_id => 2,
        :agency_id => 3
      )
    ])
  end

  it "renders a list of agency_user_mappings" do
    render
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
  end
end
