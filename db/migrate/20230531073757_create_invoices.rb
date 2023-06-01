class CreateInvoices < ActiveRecord::Migration[7.0]
  def change
    create_enum :status_enum, [:issued, :paid, :canceled, :failed, :overdue]

    create_table :invoices do |t|
      t.uuid :uuid, default: 'gen_random_uuid()'
      t.string :number, null: false
      t.string :description, null: true
      t.string :reference_number, null: true
      t.float :vat_rate, null: true
      
      t.jsonb :buyer_data, default: {}
      t.belongs_to :buyer, foreign_key: { to_table: :contacts }

      t.datetime :issue_date
      t.datetime :cancel_date
      t.datetime :due_date

      t.enum :status, enum_type: :status_enum, default: 'issued', null: false

      t.float :total, null: false, default: 0.0

      t.timestamps
    end
  end
end
