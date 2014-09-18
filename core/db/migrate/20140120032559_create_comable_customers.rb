class CreateComableCustomers < ActiveRecord::Migration
  def change
    create_table :comable_customers do |t|
      t.string :family_name, null: false
      t.string :first_name, null: false
    end
  end
end
