class AddLinksToResource < ActiveRecord::Migration
  include SearchUtil
  
  def change
    add_column :resources, :links, :text

    Resource.all.each do |r|
      r.links << ["Hollis", item_link(r.id_hollis)] unless r.id_hollis.nil?
      r.save
    end
  end
end
