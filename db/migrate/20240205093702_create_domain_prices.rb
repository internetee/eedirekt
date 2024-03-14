class CreateDomainPrices < ActiveRecord::Migration[7.0]
  def change
    create_table :domain_prices do |t|
      t.decimal :price, precision: 10, scale: 2, null: false
      t.datetime :valid_from, null: false, default: -> { "CURRENT_TIMESTAMP" }
      t.datetime :valid_to, null: true

      t.integer :duration, null: true
      t.integer :operation_category, null: false, default: 0
      t.string :zone, null: false

      t.timestamps
    end
  end
end
