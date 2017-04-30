class AddImageLinkToHospital < ActiveRecord::Migration[5.0]
  def change
    add_column :hospitals, :image_url, :text
  end
end
