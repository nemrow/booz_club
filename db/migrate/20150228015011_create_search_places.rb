class CreateSearchPlaces < ActiveRecord::Migration
  def change
    create_table :search_places do |t|
      t.integer :search_id
      t.integer :place_id
      t.boolean :result

      t.timestamps
    end
  end
end
