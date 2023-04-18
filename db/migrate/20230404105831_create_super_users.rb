class CreateSuperUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :super_users do |t|
      t.uuid :uuid, default: 'gen_random_uuid()'
      t.string :username
      t.string :password_digest
      t.string :email

      t.timestamps
    end
  end
end
