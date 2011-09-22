class AddEtherpadNameToDocument < ActiveRecord::Migration
  def up
    add_column :documents, :etherpad_name, :string, :length => 256

    Document.find_each do |doc|
      doc.save!
    end
  end

  def down
    remove_column :documents, :etherpad_name
  end
end
