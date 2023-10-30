class AddStateToContactsAndDomains < ActiveRecord::Migration[7.0]
  def change
    add_column :contacts, :state, :int, default: 0
    add_column :domains, :state, :int, default: 0
  end
end
