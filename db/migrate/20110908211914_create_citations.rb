class CreateCitations < ActiveRecord::Migration
  def change
    create_table :citations do |t|
      t.string :citation_text
      t.boolean :default, :default => false
      t.references :resource

      t.timestamps
    end
    add_index :citations, :resource_id
  end
end
