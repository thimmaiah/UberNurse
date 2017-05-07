class AddHospitalToRating < ActiveRecord::Migration[5.0]
  def change
    add_column :ratings, :hospital_id, :integer
  end
end
