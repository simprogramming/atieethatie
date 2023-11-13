class AddAvailableToCatalogItemVariation < ActiveRecord::Migration[7.0]
  def change
    add_column :catalog_item_variations, :available, :boolean, default: false
  end
end
