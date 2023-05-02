class CreateTlds < ActiveRecord::Migration[7.0]
  def change
    create_table :tlds do |t|
      t.uuid :uuid, default: 'gen_random_uuid()'
      t.string :username
      t.string :base_url
      t.string :encrypted_password
      t.string :encrypted_password_iv
      t.string :type

      t.timestamps
    end
  end
end
