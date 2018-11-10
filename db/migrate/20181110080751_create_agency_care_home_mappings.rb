class CreateAgencyCareHomeMappings < ActiveRecord::Migration[5.0]
  def change
    create_table :agency_care_home_mappings do |t|
      t.integer :care_home_id
      t.integer :agency_id

      t.timestamps
    end
  end
end
