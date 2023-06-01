class CreateInvoiceItems < ActiveRecord::Migration[7.0]
  def change
    create_table :invoice_items do |t|
      t.references :invoice, null: false, foreign_key: true
      t.string :description, null: false
      t.float :quantity, null: false, default: 0.0
      t.float :unit_price, null: false, default: 0.0

      t.timestamps
    end
  end
end
