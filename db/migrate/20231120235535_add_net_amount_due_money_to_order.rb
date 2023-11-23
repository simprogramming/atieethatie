class AddNetAmountDueMoneyToOrder < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :net_amount_due_money, :float
  end
end
