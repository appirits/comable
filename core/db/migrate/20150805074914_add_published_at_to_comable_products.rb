class AddPublishedAtToComableProducts < ActiveRecord::Migration
  def change
    change_table :comable_products do |t|
      t.datetime :published_at
    end

    reversible do |dir|
      dir.up { Comable::Product.update_all(published_at: Date.today.in_time_zone) }
    end
  end
end
