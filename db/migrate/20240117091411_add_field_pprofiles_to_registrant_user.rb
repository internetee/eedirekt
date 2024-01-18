class AddFieldPprofilesToRegistrantUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :email, :string, null: true
    add_column :users, :phone, :string, null: true
    add_column :users, :ident, :string, null: true
    add_column :users, :role, :integer, null: true
    add_column :users, :country_code, :string, null: true
    add_column :users, :city, :string, null: true
    add_column :users, :street, :string, null: true
    add_column :users, :zip, :string, null: true
    add_column :users, :state, :string, null: true
  end
end
