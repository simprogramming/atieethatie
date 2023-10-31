class AddFieldsToCategory < ActiveRecord::Migration[7.0]
  def change
    change_table :categories, bulk: true do |t|
      t.string :square_id
      t.bigint :version
    end
  end
end
