class CreateCatalogItemVariations < ActiveRecord::Migration[7.0]
  def change
    create_table :catalog_item_variations do |t|
      t.string :name_fr
      t.string :name_en
      t.references :catalog_item, null: false, foreign_key: true
      t.integer "inventory", default: 0
      t.float :price
      t.string :square_id
      t.bigint :version
      t.string :image_urls, array: true, default: []
      t.string :color
      t.string :size
      t.string :sku

      t.timestamps
    end
  end
end
