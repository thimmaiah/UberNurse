class AddNoSlotFlagToStaffingRequest < ActiveRecord::Migration[5.0]
  def change
    add_column :staffing_requests, :slot_status, :string
  end
end
