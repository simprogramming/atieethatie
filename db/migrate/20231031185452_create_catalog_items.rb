class CreateCatalogItems < ActiveRecord::Migration[7.0]
  def change
    create_table :catalog_items do |t|
      t.string :name_fr
      t.string :name_en
      t.references :category, null: false, foreign_key: true
      t.string :square_id
      t.bigint :version
      t.string :image_url

      t.timestamps
    end
  end
end
