class CreateFragrances < ActiveRecord::Migration[7.0]
  def change
    create_table :fragrances do |t|
      t.string :name_en
      t.string :name_fr
      t.references :fragrance_profile, null: false, foreign_key: true

      t.timestamps
    end
  end
end
