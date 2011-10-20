class AddCitationFormatToDocument < ActiveRecord::Migration
  def change
  	add_column :documents, :citation_format, :string
  end
end
