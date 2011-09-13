class AddApprovedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :approved, :boolean, :default => false
    add_column :users, :confirmed_at, :time
    add_column :users, :confirmation_token, :string
    add_column :users, :confirmation_sent_at, :time
  end
end
