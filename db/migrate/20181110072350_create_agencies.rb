class CreateAgencies < ActiveRecord::Migration[5.0]
  def change
    create_table :agencies do |t|
      t.string :name
      t.string :broadcast_group
      t.string :address
      t.string :postcode, limit: 10
      t.string :phone, limit: 12

      t.timestamps
    end
  end
end
