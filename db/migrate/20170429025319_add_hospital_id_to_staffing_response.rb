class AddHospitalIdToStaffingResponse < ActiveRecord::Migration[5.0]
   add_column :staffing_responses, :hospital_id, :integer
  add_index :staffing_responses, :hospital_id
end
