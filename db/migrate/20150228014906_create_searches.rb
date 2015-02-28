class CreateSearches < ActiveRecord::Migration
  def change
    create_table :searches do |t|
      t.string :description
      t.string :location
      t.integer :user_id
      t.boolean :complete, default: false

      t.timestamps
    end
  end
end
