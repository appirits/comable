Comable::Sample.import('products')

suede_dress = Comable::Product.where(name: Comable::Sample.t(:suede_dress)).first!
girly_coat = Comable::Product.where(name: Comable::Sample.t(:girly_coat)).first!
fur_gloves = Comable::Product.where(name: Comable::Sample.t(:fur_gloves)).first!
leather_boots = Comable::Product.where(name: Comable::Sample.t(:leather_boots)).first!

default_stock_attributes = {
  quantity: 10
}

variants_attributes = [
  {
    product: suede_dress,
    options: [name: Comable::Sample.t(:size), value: 'S'] + [name: Comable::Sample.t(:color), value: Comable::Sample.t(:navy)],
    stocks_attributes: [default_stock_attributes],
    sku: 'SUEDE-DRESS-SN'
  },
  {
    product: suede_dress,
    options: [name: Comable::Sample.t(:size), value: 'M'] + [name: Comable::Sample.t(:color), value: Comable::Sample.t(:navy)],
    stocks_attributes: [default_stock_attributes],
    sku: 'SUEDE-DRESS-MN'
  },
  {
    product: girly_coat,
    options: [name: Comable::Sample.t(:size), value: 'S'] + [name: Comable::Sample.t(:color), value: Comable::Sample.t(:beige)],
    stocks_attributes: [default_stock_attributes],
    sku: 'GIRLY-COAT-SB'
  },
  {
    product: girly_coat,
    options: [name: Comable::Sample.t(:size), value: 'M'] + [name: Comable::Sample.t(:color), value: Comable::Sample.t(:beige)],
    stocks_attributes: [default_stock_attributes],
    sku: 'GIRLY-COAT-MB'
  },
  {
    product: girly_coat,
    options: [name: Comable::Sample.t(:size), value: 'S'] + [name: Comable::Sample.t(:color), value: Comable::Sample.t(:navy)],
    stocks_attributes: [default_stock_attributes],
    sku: 'GIRLY-COAT-SN'
  },
  {
    product: girly_coat,
    options: [name: Comable::Sample.t(:size), value: 'M'] + [name: Comable::Sample.t(:color), value: Comable::Sample.t(:navy)],
    stocks_attributes: [default_stock_attributes],
    sku: 'GIRLY-COAT-MN'
  },
  {
    product: fur_gloves,
    stocks_attributes: [default_stock_attributes],
    sku: 'FUR-GLOVES'
  },
  {
    product: leather_boots,
    options: [name: Comable::Sample.t(:size), value: 'S'],
    stocks_attributes: [quantity: 0],
    sku: 'LEATHER-BOOTS-S'
  },
  {
    product: leather_boots,
    options: [name: Comable::Sample.t(:size), value: 'M'],
    stocks_attributes: [quantity: 1],
    sku: 'LEATHER-BOOTS-M'
  },
  {
    product: leather_boots,
    options: [name: Comable::Sample.t(:size), value: 'L'],
    stocks_attributes: [default_stock_attributes],
    sku: 'LEATHER-BOOTS-L'
  }
]

variants_attributes.each do |attributes|
  Comable::Variant.create!(attributes)
end
