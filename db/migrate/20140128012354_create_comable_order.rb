class CreateComableOrder < ActiveRecord::Migration
  def change
    create_table :comable_orders do |t|
      t.references customer_table_name
      t.string :code, null: false
      t.string :family_name, null: false
      t.string :first_name, null: false
      t.timestamps
    end
  end

  private

  def customer_table_name
    if Comable::Engine::config.respond_to?(:customer_table)
      Comable::Engine::config.customer_table.to_s.singularize
    else
      :comable_customer
    end
  end
end
