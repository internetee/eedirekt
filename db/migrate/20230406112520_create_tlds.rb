class CreateTlds < ActiveRecord::Migration[7.0]
  def change
    create_table :tlds do |t|
      t.uuid :uuid, default: 'gen_random_uuid()'
      t.string :username
      t.string :password_digest

      t.timestamps
    end
  end
end
