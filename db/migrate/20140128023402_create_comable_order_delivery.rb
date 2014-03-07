class CreateComableOrderDelivery < ActiveRecord::Migration
  def change
    create_table :comable_order_deliveries do |t|
      t.references :comable_order, null: false
      t.string :family_name, null: false
      t.string :first_name, null: false
      t.timestamps
    end
  end
end
