require 'rails_helper'

RSpec.describe "care_home_carer_mappings/index", type: :view do
  before(:each) do
    assign(:care_home_carer_mappings, [
      CareHomeCarerMapping.create!(
        :care_home_id => 2,
        :user_id => 3,
        :enabled => false,
        :distance => 4.5,
        :manually_created => false,
        :agency_id => 5
      ),
      CareHomeCarerMapping.create!(
        :care_home_id => 2,
        :user_id => 3,
        :enabled => false,
        :distance => 4.5,
        :manually_created => false,
        :agency_id => 5
      )
    ])
  end

  it "renders a list of care_home_carer_mappings" do
    render
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => 4.5.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => 5.to_s, :count => 2
  end
end
