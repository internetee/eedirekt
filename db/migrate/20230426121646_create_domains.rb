class CreateDomains < ActiveRecord::Migration[7.0]
  def change
    create_table :domains do |t|
      t.string :name
      t.string :statuses, array: true, default: []
      t.datetime :remote_created_at
      t.datetime :remote_updated_at
      t.datetime :expire_at
      t.jsonb :information, default: {}
      t.belongs_to :registrant, foreign_key: { to_table: :contacts }

      t.timestamps
    end
  end
end
