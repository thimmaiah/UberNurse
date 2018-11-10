class AddIndexToMappings < ActiveRecord::Migration[5.0]
  def change
  	add_index :agency_user_mappings, :agency_id
  	add_index :agency_care_home_mappings, :agency_id
  	add_index :agency_user_mappings, :user_id
  	add_index :agency_care_home_mappings, :care_home_id
  end
end
