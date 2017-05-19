class AddVerifiedToHospital < ActiveRecord::Migration[5.0]
  def change
    add_column :hospitals, :verified, :boolean
  end
end
