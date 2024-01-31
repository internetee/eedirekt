class AddErrorFieldToActionPendings < ActiveRecord::Migration[7.0]
  def change
    add_column :pending_actions, :errors_in_response, :jsonb, default: {}
  end
end
