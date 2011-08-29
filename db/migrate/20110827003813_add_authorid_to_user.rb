class AddAuthoridToUser < ActiveRecord::Migration
  def change
    add_column :users, :author_id, :string
  end
end
