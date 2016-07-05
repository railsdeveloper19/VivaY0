class AddUserDetailsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :state, :string
    add_column :users, :address, :string
    add_column :users, :gender, :string
    add_column :users, :dob, :datetime
    add_column :users, :contact, :integer ,:limit =>8
    add_column :users, :qualification, :string
    add_column :users, :occupation, :string
    add_column :users, :objective, :string
    add_column :users, :work, :string
    add_column :users, :few_words, :string
    add_column :users, :user_type, :string
  end
end
