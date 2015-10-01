class AddPropertyToComableProducts < ActiveRecord::Migration
  def change
    add_column :comable_products, :property, :string, after: :caption
  end
end
