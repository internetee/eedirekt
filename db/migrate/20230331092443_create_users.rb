class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.uuid :uuid, default: 'gen_random_uuid()'
      t.string :name
      t.string :code

      t.timestamps
    end
  end
end
