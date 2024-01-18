class CreatePendingActions < ActiveRecord::Migration[7.0]
  def change
    create_table :pending_actions do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :invoice, null: true, foreign_key: true
      t.jsonb :info, null: false, default: {}
      
      t.integer :action, null: false, default: 0
      t.integer :status, null: false, default: 0
      
      t.timestamps
    end
  end
end
