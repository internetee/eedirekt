class CreateSettings < ActiveRecord::Migration[7.0]
  def change
    create_table :settings do |t|
      t.string :code, null: false, index: { unique: true }
      t.string :value, null: true
      t.string :group, null: false
      t.string :format, null: false

      t.timestamps
    end
  end
end
