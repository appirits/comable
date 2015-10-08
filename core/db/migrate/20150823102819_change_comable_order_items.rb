class ChangeComableOrderItems < ActiveRecord::Migration
  def change
    reversible do |dir|
      change_table :comable_order_items do |t|
        dir.up   { t.references :variant }
        dir.down { t.remove :variant_id }
      end

      dir.up   { up_records }
      dir.down { down_records }

      change_table :comable_order_items do |t|
        dir.up   { t.remove :stock_id }
        dir.down { t.references :stock, null: false }

        dir.up   { t.rename :code, :sku }
        dir.down { t.rename :sku, :code }

        dir.up   { t.change :sku, :string, null: true }
        dir.down { t.change :code, :string, null: false }

        dir.up   { t.remove :sku_h_item_name }
        dir.down { t.string :sku_h_item_name }

        dir.up   { t.remove :sku_v_item_name }
        dir.down { t.string :sku_v_item_name }

        dir.up   { t.remove :sku_h_choice_name }
        dir.down { t.string :sku_h_choice_name }

        dir.up   { t.remove :sku_v_choice_name }
        dir.down { t.string :sku_v_choice_name }

        dir.up   { t.change :variant_id, :integer, null: false }
      end
    end
  end

  private

  def up_records
    Comable::OrderItem.all.each do |order_item|
      stock = Comable::Stock.find(order_item.stock_id)
      order_item.update_attribute(:variant_id, stock.variant_id)
    end
  end

  def down_records
  end
end
