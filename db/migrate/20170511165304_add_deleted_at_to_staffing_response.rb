class AddDeletedAtToStaffingResponse < ActiveRecord::Migration[5.0]
  def change
    add_column :staffing_responses, :deleted_at, :datetime
    add_index :staffing_responses, :deleted_at
  end
end
