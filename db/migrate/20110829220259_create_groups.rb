class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.timestamps
    end

    add_column :documents, :group_id, :integer

    create_table :groups_users, :id => false do |t|
      t.integer :group_id,  :null => false
      t.integer :user_id,   :null => false
    end
  end
end
