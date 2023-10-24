class AddDescriptionsToSettings < ActiveRecord::Migration[7.0]
  def change
    add_column :settings, :description, :string, null: true
  end
end
