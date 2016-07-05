class CreateUserMappings < ActiveRecord::Migration
  def change
    create_table :user_mappings do |t|
      t.integer :user_id
      t.integer :join_id

      t.timestamps null: false
    end
  end
end
