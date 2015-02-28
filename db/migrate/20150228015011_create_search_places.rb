class CreateSearchPlaces < ActiveRecord::Migration
  def change
    create_table :search_places do |t|
      t.integer :search_id
      t.integer :place_id
      t.boolean :result
      t.string :recording_url

      t.timestamps
    end
  end
end
