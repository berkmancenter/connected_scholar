class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.string :name
      t.references :owner, :polymorphic => { :default => 'User' }
      t.timestamps
    end
  end
end
