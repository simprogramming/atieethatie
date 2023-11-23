class MakeFragranceOptionalInCatalogItems < ActiveRecord::Migration[7.0]
  def change
    change_column_null :catalog_items, :fragrance_id, true
  end
end
