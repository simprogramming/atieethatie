class CreateFragranceProfiles < ActiveRecord::Migration[7.0]
  def change
    create_table :fragrance_profiles do |t|
      t.string :name_en
      t.string :name_fr

      t.timestamps
    end
  end
end
