class CreateAddresses < ActiveRecord::Migration[7.0]
  def change
    create_table :addresses do |t|
      t.string :address_type
      t.string :first_name
      t.string :last_name
      t.string :address_line
      t.string :company
      t.string :apartment
      t.string :city
      t.string :province
      t.string :postal_code
      t.string :country
      t.references :order, null: false, foreign_key: true

      t.timestamps
    end
  end
end
