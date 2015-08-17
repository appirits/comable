class CreateComableNavigationItem < ActiveRecord::Migration
  def change
    create_table :comable_navigation_items do |t|
      t.references :navigation, null: false
      t.integer :linkable_id
      t.string :linkable_type
      t.integer :position, null: false
      t.string :name, null: false
      t.string :url
      t.timestamps null: false
    end

    add_index :comable_navigation_items, [:position, :navigation_id]
  end
end
