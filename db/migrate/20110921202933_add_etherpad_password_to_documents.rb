class AddEtherpadPasswordToDocuments < ActiveRecord::Migration
  def up
    add_column :documents, :etherpad_password, :string, :length => 50

    execute("select id from documents").each do |row|
      execute "update documents set etherpad_password='#{SecureRandom.hex(13)}' where id=#{row['id']}"
    end
  end

  def down
    remove_column :documents, :etherpad_password
  end
end
