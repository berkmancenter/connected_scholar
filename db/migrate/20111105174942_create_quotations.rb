class CreateQuotations < ActiveRecord::Migration
  def change
    create_table :quotations do |t|
      t.text :quote
      t.references :resource

      t.timestamps
    end
    add_index :quotations, :resource_id
  end
end
