class CreateResources < ActiveRecord::Migration
  def change
    create_table :resources do |t|
      t.string :title
      t.string :authors
      t.date :publication_date
      t.string :source
      t.string :isbn
      t.string :url
      t.text :abstract
      t.references :document

      t.timestamps
    end
    add_index :resources, :document_id
  end
end
