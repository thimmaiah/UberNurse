class AddSmsPasswdResetToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :password_reset_code, :string, limit: 10
    add_column :users, :password_reset_date, :date
  end
end
