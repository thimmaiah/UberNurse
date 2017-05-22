class AddCareHomeIdToStaffingResponse < ActiveRecord::Migration[5.0]
   add_column :staffing_responses, :care_home_id, :integer
  add_index :staffing_responses, :care_home_id
end
