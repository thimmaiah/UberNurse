require 'rails_helper'

RSpec.describe "care_home_carer_mappings/show", type: :view do
  before(:each) do
    @care_home_carer_mapping = assign(:care_home_carer_mapping, CareHomeCarerMapping.create!(
      :care_home_id => 2,
      :user_id => 3,
      :enabled => false,
      :distance => 4.5,
      :manually_created => false,
      :agency_id => 5
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/4.5/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/5/)
  end
end
