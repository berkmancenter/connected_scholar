class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :comment_text
      t.references :author, :polymorphic => { :default => 'User' }
      t.references :document
      t.timestamps
    end
  end
end
