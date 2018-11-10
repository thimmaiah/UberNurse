class RemoveAgencyIdFromUser < ActiveRecord::Migration[5.0]
  def change
	remove_column :users, :agency_id
	remove_column :care_homes, :agency_id
  end
end
