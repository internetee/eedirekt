class CreateNameservers < ActiveRecord::Migration[7.0]
  def change
    create_table :nameservers do |t|
      t.uuid :uuid, default: 'gen_random_uuid()'

      t.string :hostname
      t.string :ipv4, array: true, default: []
      t.string :ipv6, array: true, default: []
      t.references :domain

      t.timestamps
    end
  end
end
