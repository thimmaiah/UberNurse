class CreateAgencyUserMappings < ActiveRecord::Migration[5.0]
  def change
    create_table :agency_user_mappings do |t|
      t.integer :user_id
      t.integer :agency_id

      t.timestamps
    end
  end
end
