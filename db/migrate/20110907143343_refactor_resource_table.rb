class RefactorResourceTable < ActiveRecord::Migration
  def up
    create_table :resources, :force => true do |t|
      t.string "title"
      t.string "pub_location"
      t.string "num_page"
      t.string "id_lccn"
      t.date "publication_date"
      t.string "sub_title"
      t.string "desc_subject"
      t.string "creators"
      t.string "publisher"
      t.string "id_librarycloud"
      t.string "height"
      t.string "source"
      t.string "material_format"
      t.string "id_oclc"
      t.string "id_lc_call_num"
      t.string "id_hollis"
      t.string "language"
      t.string "id_isbn"

      t.integer "document_id"
      t.timestamps
    end

  end

  def down
    create_table "resources", :force => true do |t|
      t.string "title"
      t.string "authors"
      t.date "publication_date"
      t.string "source"
      t.string "isbn"
      t.string "url"
      t.text "abstract"
      t.integer "document_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end
end
