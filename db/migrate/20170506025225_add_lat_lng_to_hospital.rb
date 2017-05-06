class AddLatLngToHospital < ActiveRecord::Migration[5.0]
  def change
    add_column :hospitals, :lat, :decimal, precision: 18, scale: 15
    add_column :hospitals, :lng, :decimal, precision: 18, scale: 15
  end
end
