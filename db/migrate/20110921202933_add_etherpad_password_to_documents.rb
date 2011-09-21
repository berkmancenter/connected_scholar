class AddEtherpadPasswordToDocuments < ActiveRecord::Migration
  def change
    add_column :documents, :etherpad_password, :string, :length => 50
  end
end
