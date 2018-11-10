require 'rails_helper'

RSpec.describe "agency_care_home_mappings/index", type: :view do
  before(:each) do
    assign(:agency_care_home_mappings, [
      AgencyCareHomeMapping.create!(
        :care_home_id => 2,
        :agency_id => 3
      ),
      AgencyCareHomeMapping.create!(
        :care_home_id => 2,
        :agency_id => 3
      )
    ])
  end

  it "renders a list of agency_care_home_mappings" do
    render
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
  end
end
