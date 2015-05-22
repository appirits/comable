Comable::Sample.import('products')

suede_dress = Comable::Product.find_by!(name: Comable::Sample.t(:suede_dress))
girly_coat = Comable::Product.find_by!(name: Comable::Sample.t(:girly_coat))
fur_gloves = Comable::Product.find_by!(name: Comable::Sample.t(:fur_gloves))
leather_boots = Comable::Product.find_by!(name: Comable::Sample.t(:leather_boots))

suede_dress.update_attributes!(sku_h_item_name: Comable::Sample.t(:size), sku_v_item_name: Comable::Sample.t(:color))
girly_coat.update_attributes!(sku_h_item_name: Comable::Sample.t(:size), sku_v_item_name: Comable::Sample.t(:color))
leather_boots.update_attributes!(sku_h_item_name: Comable::Sample.t(:size))

default_stock_attributes = {
  quantity: 10
}

stocks_attributes = [
  {
    product: suede_dress,
    code: "#{suede_dress.code}-SN",
    sku_h_choice_name: 'S',
    sku_v_choice_name: Comable::Sample.t(:navy)
  },
  {
    product: suede_dress,
    code: "#{suede_dress.code}-MN",
    sku_h_choice_name: 'M',
    sku_v_choice_name: Comable::Sample.t(:navy)
  },
  {
    product: girly_coat,
    code: "#{girly_coat.code}-SB",
    sku_h_choice_name: 'S',
    sku_v_choice_name: Comable::Sample.t(:beige)
  },
  {
    product: girly_coat,
    code: "#{girly_coat.code}-MB",
    sku_h_choice_name: 'M',
    sku_v_choice_name: Comable::Sample.t(:beige)
  },
  {
    product: girly_coat,
    code: "#{girly_coat.code}-SN",
    sku_h_choice_name: 'S',
    sku_v_choice_name: Comable::Sample.t(:navy)
  },
  {
    product: girly_coat,
    code: "#{girly_coat.code}-MN",
    sku_h_choice_name: 'M',
    sku_v_choice_name: Comable::Sample.t(:navy)
  },
  {
    product: fur_gloves,
    code: fur_gloves.code
  },
  {
    product: leather_boots,
    code: "#{leather_boots.code}-S",
    sku_h_choice_name: 'S',
    quantity: 0
  },
  {
    product: leather_boots,
    code: "#{leather_boots.code}-M",
    sku_h_choice_name: 'M',
    quantity: 1
  },
  {
    product: leather_boots,
    code: "#{leather_boots.code}-L",
    sku_h_choice_name: 'L'
  }
]

stocks_attributes.each do |attributes|
  Comable::Stock.create!(default_stock_attributes.merge(attributes))
end
