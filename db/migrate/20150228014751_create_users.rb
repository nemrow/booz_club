class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :cell

      t.timestamps
    end
  end
end
