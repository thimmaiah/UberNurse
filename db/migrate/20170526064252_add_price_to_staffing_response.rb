class AddPriceToStaffingResponse < ActiveRecord::Migration[5.0]
  def change
    add_column :staffing_responses, :price, :float
    add_column :staffing_responses, :pricing_audit, :text
  end
end
