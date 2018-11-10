require 'rails_helper'

RSpec.describe "agency_user_mappings/show", type: :view do
  before(:each) do
    @agency_user_mapping = assign(:agency_user_mapping, AgencyUserMapping.create!(
      :user_id => 2,
      :agency_id => 3
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
  end
end
