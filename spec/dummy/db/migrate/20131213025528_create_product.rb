class CreateProduct < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name, nil: false
      t.timestamps
    end
  end
end
