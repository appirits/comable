class AddThemeIdToComableStores < ActiveRecord::Migration
  def change
    change_table :comable_stores do |t|
      t.references :theme
    end
  end
end
