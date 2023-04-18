class CreateRegistrarUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :registrar_users do |t|
      t.uuid :uuid, default: 'gen_random_uuid()'
      t.string :name
      t.string :code
      t.string :username
      t.string :password_digest

      t.timestamps
    end
  end
end
