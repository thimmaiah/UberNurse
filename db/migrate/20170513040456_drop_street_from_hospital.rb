class DropStreetFromHospital < ActiveRecord::Migration[5.0]
  def change
	remove_column :hospitals, :street
	remove_column :hospitals, :locality
  end
end
