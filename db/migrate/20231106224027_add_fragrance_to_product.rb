class AddFragranceToProduct < ActiveRecord::Migration[7.0]
  def change
    change_table :catalog_items, bulk: true do |t|
      t.references :fragrance, null: false, foreign_key: true
    end
  end
end
