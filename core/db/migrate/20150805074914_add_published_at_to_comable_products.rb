class AddPublishedAtToComableProducts < ActiveRecord::Migration
  def change
    change_table :comable_products do |t|
      t.datetime :published_at
    end
  end
end
