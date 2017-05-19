class AddStartAndEndTimeToStaffingResponse < ActiveRecord::Migration[5.0]
  def change
    add_column :staffing_responses, :start_date, :datetime
    add_column :staffing_responses, :end_date, :datetime
  end
end
