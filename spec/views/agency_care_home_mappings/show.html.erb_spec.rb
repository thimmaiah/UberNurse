require 'rails_helper'

RSpec.describe "agency_care_home_mappings/show", type: :view do
  before(:each) do
    @agency_care_home_mapping = assign(:agency_care_home_mapping, AgencyCareHomeMapping.create!(
      :care_home_id => 2,
      :agency_id => 3
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
  end
end
