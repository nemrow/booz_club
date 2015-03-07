class AddCancelledToSearch < ActiveRecord::Migration
  def change
    add_column :searches, :cancelled, :string
  end
end
