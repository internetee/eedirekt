class CreateDomainContacts < ActiveRecord::Migration[7.0]
  def change
    create_table :domain_contacts do |t|
      t.uuid :uuid, default: 'gen_random_uuid()'

      t.references :domain
      t.references :contact

      t.string :type

      t.timestamps
    end
  end
end
