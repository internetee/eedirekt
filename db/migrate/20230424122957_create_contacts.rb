class CreateContacts < ActiveRecord::Migration[7.0]
  def change
    create_table :contacts do |t|
      t.string :email, null: true
      t.string :name, null: true
      t.string :phone, null: true
      t.string :ident, null: true
      t.string :code, null: true
      t.string :authInfo, null: true
      t.integer :role, null: true
      t.string :country_code, null: true
      t.jsonb :information, null: true, default: {}
      t.datetime :remote_updated_at, null: true

      t.timestamps
    end
  end
end
