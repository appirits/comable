class AddPropertyToComableProducts < ActiveRecord::Migration
  def change
    add_column :comable_products, :property, :text, after: :caption
  end
end
