class CreateImages < ActiveRecord::Migration[7.0]
  def change
    create_table :images do |t|
      t.string :image_url
      t.string :square_id
      t.string :imageable_type
      t.bigint :imageable_id

      t.timestamps
    end
    add_index :images, [:imageable_type, :imageable_id]

    remove_column :catalog_item_variations, :image_urls, :array
    remove_column :catalog_item_variations, :image_ids, :array
    remove_column :catalog_items, :image_url, :string
  end
end
