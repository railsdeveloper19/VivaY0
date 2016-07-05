class CreatePhotos < ActiveRecord::Migration
  def self.up
    create_table :photos do |t|
      t.string :description
      t.binary :data,         :null => false
      t.string :filename
      t.string :mime_type
      t.integer :photable_id
      t.string :photable_type
      t.timestamps
    end
  end

  def self.down
    drop_table :photos
  end
end
