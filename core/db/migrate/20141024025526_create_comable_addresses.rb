class CreateComableAddresses < ActiveRecord::Migration
  def change
    create_table :comable_addresses do |t|
      t.integer :comable_customer_id
      t.string :family_name, null: false
      t.string :first_name, null: false
      t.string :zip_code, null: false, limit: 8
      t.integer :comable_state_id
      t.string :state_name, null: false
      t.string :city, null: false
      t.string :detail
      t.string :phone_number, null: false, limit: 18
      t.datetime :last_used_at
    end
  end
end
