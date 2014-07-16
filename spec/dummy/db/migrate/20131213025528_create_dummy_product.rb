class CreateDummyProduct < ActiveRecord::Migration
  def change
    create_table :dummy_products do |t|
      t.string :title, nil: false
      t.timestamps
    end
  end
end
