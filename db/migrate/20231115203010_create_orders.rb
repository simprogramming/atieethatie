class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.string :session_id
      t.datetime :paid_at
      t.integer :version
      t.string :square_id
      t.string :state

      t.timestamps
    end
  end
end
