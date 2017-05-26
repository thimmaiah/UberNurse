class AddConfirmToStaffingResponse < ActiveRecord::Migration[5.0]
  def change
    add_column :staffing_responses, :confirm_sent_count, :integer
    add_column :staffing_responses, :confirm_sent_at, :date
    add_column :staffing_responses, :confirmed_status, :string
    add_column :staffing_responses, :confirmed_count, :integer
    add_column :staffing_responses, :confirmed_at, :date
  end
end
