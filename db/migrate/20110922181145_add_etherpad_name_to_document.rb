class AddEtherpadNameToDocument < ActiveRecord::Migration
  def up
    add_column :documents, :etherpad_name, :string, :length => 256

    Document.find_each do |doc|
      execute "update documents set etherpad_name=#{CGI::escape(doc.name)} where id=#{doc.id}"
    end
  end

  def down
    remove_column :documents, :etherpad_name
  end
end