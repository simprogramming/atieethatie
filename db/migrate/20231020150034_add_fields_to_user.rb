class AddFieldsToUser < ActiveRecord::Migration[7.0]
  def change
    change_table :users, bulk: true do |t|
      t.string :role
      t.string :first_name
      t.string :last_name
    end
  end
end
