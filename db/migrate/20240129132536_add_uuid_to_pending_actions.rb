class AddUuidToPendingActions < ActiveRecord::Migration[7.0]
  def change
    add_column :pending_actions, :uuid, :uuid, default: 'gen_random_uuid()'
  end
end
