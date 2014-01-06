class CreateProduct < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :title, nil: false
      t.timestamps
    end
  end
end
