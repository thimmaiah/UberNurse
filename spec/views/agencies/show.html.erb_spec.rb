require 'rails_helper'

RSpec.describe "agencies/show", type: :view do
  before(:each) do
    @agency = assign(:agency, Agency.create!(
      :name => "Name",
      :broadcast_group => "Broadcast Group",
      :address => "Address",
      :postcode => "Postcode",
      :phone => "Phone"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Broadcast Group/)
    expect(rendered).to match(/Address/)
    expect(rendered).to match(/Postcode/)
    expect(rendered).to match(/Phone/)
  end
end
