class AddIsReadToComments < ActiveRecord::Migration
  def change
    add_column :comments, :is_read, :boolean, :default => false
  end
end
