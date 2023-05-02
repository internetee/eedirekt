class CreateDnssecKeys < ActiveRecord::Migration[7.0]
  def change
    create_table :dnssec_keys do |t|
      t.integer :flags
      t.integer :protocol
      t.integer :algorithm

      t.string :public_key
      t.references :domain

      t.timestamps
    end
  end
end
