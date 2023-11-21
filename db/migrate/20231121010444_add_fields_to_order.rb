class AddFieldsToOrder < ActiveRecord::Migration[7.0]
  def change
    change_table :orders, bulk: true do |t|
      t.string :payment_id
      t.string :receipt_number
      t.string :receipt_url
    end
  end
end
