require 'rails_helper'

RSpec.describe "care_home_carer_mappings/new", type: :view do
  before(:each) do
    assign(:care_home_carer_mapping, CareHomeCarerMapping.new(
      :care_home_id => 1,
      :user_id => 1,
      :enabled => false,
      :distance => 1.5,
      :manually_created => false,
      :agency_id => 1
    ))
  end

  it "renders new care_home_carer_mapping form" do
    render

    assert_select "form[action=?][method=?]", care_home_carer_mappings_path, "post" do

      assert_select "input#care_home_carer_mapping_care_home_id[name=?]", "care_home_carer_mapping[care_home_id]"

      assert_select "input#care_home_carer_mapping_user_id[name=?]", "care_home_carer_mapping[user_id]"

      assert_select "input#care_home_carer_mapping_enabled[name=?]", "care_home_carer_mapping[enabled]"

      assert_select "input#care_home_carer_mapping_distance[name=?]", "care_home_carer_mapping[distance]"

      assert_select "input#care_home_carer_mapping_manually_created[name=?]", "care_home_carer_mapping[manually_created]"

      assert_select "input#care_home_carer_mapping_agency_id[name=?]", "care_home_carer_mapping[agency_id]"
    end
  end
end
