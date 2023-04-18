class CreateAppSessions < ActiveRecord::Migration[7.0]
  def change
    create_table :app_sessions do |t|
      t.uuid :uuid, default: 'gen_random_uuid()'
      t.references :sessionable, polymorphic: true
      t.string :token_digest

      t.timestamps
    end
  end
end
