class ChangeComableProductsAndComableStocks < ActiveRecord::Migration
  def change
    reversible do |dir|
      change_table :comable_stocks do |t|
        dir.up   { t.references :variant }
        dir.down { t.remove :variant_id }
      end

      dir.up   { up_records }
      dir.down { down_records }

      dir.up   { remove_index :comable_products, :code }
      dir.down { add_index :comable_products, :code, unique: true }

      change_table :comable_products do |t|
        dir.up   { t.remove :code }
        dir.down { t.string :code, null: false }

        dir.up   { t.remove :price }
        dir.down { t.string :price, null: false }

        dir.up   { t.remove :sku_h_item_name }
        dir.down { t.string :sku_h_item_name }

        dir.up   { t.remove :sku_v_item_name }
        dir.down { t.string :sku_v_item_name }
      end

      dir.up   { remove_index :comable_stocks, :code }
      dir.down { add_index :comable_stocks, :code, unique: true }

      change_table :comable_stocks do |t|
        dir.up   { t.remove :product_id }
        dir.down { t.references :product, null: false }

        dir.up   { t.remove :code }
        dir.down { t.string :code, null: false }

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
    Comable::Product.all.each do |product|
      if product.sku_h_item_name? || product.sku_h_item_name?
        create_variants_for(product)
      else
        create_variant_for(product)
      end
    end
  end

  def down_records
    # TODO: Implement
  end

  def create_variant_for(product)
    stock = Comable::Stock.find_by(product_id: product.id)
    product.variants.create!(stock: stock, price: product.price, sku: product.code)
  end

  def create_variants_for(product)
    option_type_h = product.option_types.create!(name: product.sku_h_item_name) if product.sku_h_item_name?
    option_type_v = product.option_types.create!(name: product.sku_v_item_name) if product.sku_v_item_name?

    Comable::Stock.where(product_id: product.id).each do |stock|
      option_values = []
      option_values << option_type_h.option_values.where(name: stock.sku_h_choice_name).first_or_initialize if option_type_h
      option_values << option_type_v.option_values.where(name: stock.sku_v_choice_name).first_or_initialize if option_type_v
      product.variants.create!(stock: stock, price: product.price, sku: stock.code, option_values: option_values)
    end
  end
end
