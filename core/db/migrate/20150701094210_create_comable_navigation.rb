class CreateComableNavigation < ActiveRecord::Migration
  def change
    create_table :comable_navigations do |t|
      t.string :name, null: false
      t.timestamps null: false
    end
  end
end
