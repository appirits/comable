class CreateComablePayments < ActiveRecord::Migration
  def change
    create_table :comable_payments do |t|
      t.string :name, null: false
      t.string :payment_method_type, null: false
      t.integer :payment_method_kind, null: false
      t.integer :enable_price_from
      t.integer :enable_price_to
    end
  end
end
