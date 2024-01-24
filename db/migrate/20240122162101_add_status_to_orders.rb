class AddStatusToOrders < ActiveRecord::Migration[7.0]
  def change
    change_table :orders, bulk: true do |t|
      t.string :shipping_status
      t.date :shipping_date
    end
  end
end
