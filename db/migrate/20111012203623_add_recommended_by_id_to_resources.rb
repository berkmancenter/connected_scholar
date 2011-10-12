class AddRecommendedByIdToResources < ActiveRecord::Migration
  def change
    add_column :resources, :recommended_by_id, :integer
  end
end
